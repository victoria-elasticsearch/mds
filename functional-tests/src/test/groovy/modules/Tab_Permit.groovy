package modules

import geb.Module 

class Tab_Permit extends Module {
    static at = {activeTab=='Permit'}
    static content = {
        activeTab (wait:true) {$("div.ant-tabs-tab-active").text()}
        tabSelect (wait:true) {$("div.ant-tabs-tab", text: "Permit")}

        permit_no (wait:true) {$("td", 'data-label':'Permit').find("p.p-large")}
        permit_date (wait:true) {$("td", 'data-label':'Date Issued').find("p.p-large")} 
         
    }
    
}

 
        