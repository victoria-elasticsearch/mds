package spec

import geb.spock.GebReportingSpec
import spock.lang.*


import pages.*
import utils.* 
import dataObjects.managerProfileData

 
@Title("MDS-MineProfilePage")
@Stepwise
class  C_SummarySpec extends GebReportingSpec {

    def "Scenario: User can view the mine profile"(){
        when: "I go to the mine profile page for BLAH0000(the test record)"
        to MineProfilePage 

        then: "I should see profile of the Mine"    
        assert mineNumber == "Mine ID: "+Const.MINE_NUMBER
        assert mineName == Const.MINE_NAME
        assert latValue.minus("Lat:").startsWith(Const.MINE_LAT)
        assert longValue.minus("Long:").startsWith(Const.MINE_LONG)
    }
}



