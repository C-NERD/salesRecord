script {
    use sales_record::sales_record;
    use std::signer;
    use std::string;
    use aptos_framework::aptos_coin::{ AptosCoin };
    use aptos_framework::coin::{ transfer };

    fun main(signer : &signer, seller : address) {
        
        // create records
        sales_record::create_records_if_not_exists(signer);
        
        // buy from seller on credit
        sales_record::add_record(
            signer, 
            string::utf8(b"Minimie chin chin"),
            string::utf8(b"Tasty snack for a hungry beast, yum yum! :)"),
            300
        ); // buy minime
        sales_record::add_record(
            signer,
            string::utf8(b"Nice biscuit"),
            string::utf8(b"Sweet dry biscuit"),
            350
        ); // buy biscuit

        // pay back debt
        let signer_address = signer::address_of(signer);
        let record_length = sales_record::get_record_length(signer_address);
        let i : u64 = 0;
        let total_price : u64 = 0;
        while (i < record_length) {
            
            let (_, _, price) = sales_record::get_record_by_index(signer_address, i); 
            total_price = total_price + price;
            i = i + 1;
        }; // calculate total
        
        if (total_price > 0) {
            
            transfer<AptosCoin>(signer, seller, total_price); // payup
        };
    }
}
