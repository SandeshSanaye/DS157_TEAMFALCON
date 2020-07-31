package main

// MaharashtraFormVII represt village form 7 which consists of below mentioned column
// 01. Name of the village
// 02. Name of the taluka
// 03. Survey No/Gat No. and its sub division Number.
// 04. Tenure: (Marathi-Bhudharana paddhti-Type of occupancy)
// 05. Name of the occupant: Occupant is a person having lawful and actual possession of the land whereas occupancy
//     means portion of the land held by the occupant. Occupant is responsible to pay land revenue to
//     the Government. Occupancy is liable to forfeiture in case occupant fails to pay land revenue to
//     the Government. On forfeiture occupant and his hairs loses all their right on the land.
//     Occupancy is transferable immovable property. The way of transfer may be by sale,
//     by mortgage, by lease, by exchange, by gift or by his will.
// 06. Local name of the field Considering shape or location of the field farmers has given names to their field,
//     for example ohalacha mal (field where spring water is flowing).
// 07. Cultivable area Total
// 08. Uncultivable land (Marathi-Pot kharaba) class (a) and Class(b) Total:
//     It means uncultivable portion of the land. It is of two kinds-
// 		 a) that which is classed as a unfit for the cultivation i.e rocky area, land under nala and farm building etc.
// 		 b) that which is reserved for  public purpose i.e. road, recognized foot path and public place of drinking water etc.
// 09. Assessment
// 10. Judi or special assessment
// 11. Khata No.
// 12. Rent Rs. P.
// 13. Other rights
type MaharashtraFormVII struct {
	SurveyNo        string   `json:"surveyNo"`
	GatNo           string   `json:"gatNo"`
	Tenure          string   `json:"tenure"`
	AccountNumber   []string `json:"accountNumber"`
	LocalName       string   `json:"localName"`
	TenantName      string   `json:"tenantName"`
	OccupantDetails []struct {
		OccupantName   string `json:"occupantName"`
		Area           string `json:"area"`
		Aakar          string `json:"aakar"`
		KhataNo        string `json:"khataNo"`
		MutationNumber string `json:"mutationNumber"`
	}
	CultivableArea struct {
		DryCrop string `json:"dryCrop"`
		Garden  string `json:"garden"`
		Rice    string `json:"rice"`
		Varkas  string `json:"varkas"`
		Other   string `json:"other"`
	}
	UncultivableLand struct {
		UncultivableLandClassA string `json:"uncultivableLandClassA"`
		UncultivableLandClassB string `json:"uncultivableLandClassB"`
	}
	Assessment        string   `json:"assessment"`
	SpecialAssessment string   `json:"specialAssessment"`
	Rent              string   `json:"rent"`
	OtherRight        string   `json:"otherRight"`
	Other             string   `json:"other"`
	Piece             string   `json:"piece"`
	OldMutationNumber []string `json:"oldMutationNumber"`
	BorderOrSymbol    string   `json:"borderOrSymbol"`
}

// Verify validate data and return flag with key
func (formVII MaharashtraFormVII) Verify(villageUID string) (bool, string) {
	if formVII.SurveyNo == "" || len(formVII.OccupantDetails) <= 0 {
		return false, ""
	}

	return true, villageUID + formVII.SurveyNo + "/" + formVII.GatNo
}
