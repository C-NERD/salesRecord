module sales_record::sales_record{
    use std::vector;
    use std::string;
    use std::signer;
    use std::error;

    struct Record has store, drop, copy {
        name : string::String,
        description : string::String,
        price : u64
    }

    struct Records has key, copy {
        records : vector<Record>
    }

    const ERECORDS_NOT_EXISTS : u64 = 0;
    const EINDEX_OUT_OF_RANGE : u64 = 1;
    
    #[view]
    public fun get_record_length(account_address : address) : u64 acquires Records {

        assert!(exists<Records>(account_address), error::not_found(ERECORDS_NOT_EXISTS)); // throws error if records does not exists
        let records = &borrow_global<Records>(account_address).records;

        vector::length<Record>(records) // return records length
    }
    
    #[view]
    public fun get_record_by_index(account_address : address, index : u64) : (string::String, string::String, u64) acquires Records {

        assert!(exists<Records>(account_address), error::not_found(ERECORDS_NOT_EXISTS)); // throws error if records does not exists
        let records = &borrow_global<Records>(account_address).records;

        assert!(index < vector::length<Record>(records), error::out_of_range(EINDEX_OUT_OF_RANGE)); // checks if index is within records range
        let record = vector::borrow<Record>(records, index);

        (record.name, record.description, record.price) // return record
    }

    fun create_records_internal(account : &signer) {
        
        move_to<Records>(account, Records{
            
            records : vector::empty<Record>()
        });
    }

    public fun create_records_if_not_exists(account : &signer) {
         
        let account_address = signer::address_of(account);
        assert!(!exists<Records>(account_address), error::not_found(ERECORDS_NOT_EXISTS)); // throws error if records exists
            
        create_records_internal(account);
    }
    
    fun add_record_internal(account_address : address, name : string::String, description : string::String, price : u64) acquires Records {
        
        let records = &mut borrow_global_mut<Records>(account_address).records;
        vector::push_back(records, Record{
            name,
            description,
            price
        });
    }

    public fun add_record(account : &signer, name : string::String, description : string::String, price : u64) acquires Records {
        
        let account_address = signer::address_of(account);

        // make sure that name is not longer 20 characters and description is not longer than 60 characters
        assert!(string::length(&name) <= 20, error::out_of_range(EINDEX_OUT_OF_RANGE));
        assert!(string::length(&description) <= 60, error::out_of_range(EINDEX_OUT_OF_RANGE));

        add_record_internal(account_address, name, description, price);
    }
}
