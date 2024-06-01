#[test_only]
module sales_record::sales_record_test{
    use sales_record::sales_record;
    use std::signer;
    use std::string;
    use std::error;

    const EINVALID_RECORD_LENGTH : u64 = 0;
    const EINVALID_RECORD_DATA : u64 = 1;

    #[test(arg1 = @0x11110101)]
    fun total_test(arg1 : &signer) {
        
        sales_record::create_records_if_not_exists(arg1); // create new records resource

        let account_address = signer::address_of(arg1);
        let product_name = string::utf8(b"Minimie chin chin");
        let product_description = string::utf8(b"Tasty snack for a hungry beast, yum yum! :)");
        let product_price : u64 = 300;
        sales_record::add_record(
            arg1,
            product_name,
            product_description,
            product_price
        ); // add product sale to record

        assert!(
            sales_record::get_record_length(account_address) == 1, 
            error::invalid_state(EINVALID_RECORD_LENGTH)
        ); // validate records length

        let (record_name, record_description, record_price) = sales_record::get_record_by_index(account_address, 0);
        // validate saved_record data
        assert!(
            record_name == product_name,
            error::invalid_state(EINVALID_RECORD_DATA)
        );
        assert!(
            record_description == product_description,
            error::invalid_state(EINVALID_RECORD_DATA)
        );
        assert!(
            record_price == product_price,
            error::invalid_state(EINVALID_RECORD_DATA)
        );
    }
}
