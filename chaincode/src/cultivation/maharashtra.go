package main

// MaharashtraFormXII represt village form 12 which consists of below mentioned column
type MaharashtraFormXII struct {
	SurveyNo             string `json:"surveyNO"`
	GatNo                string `json:"gatNo"`
	Year                 int    `json:"year"`
	Season               string `json:"season"`
	DetailsOfCroppedArea struct {
		MixedCropsArea struct {
			MixureCode       string `json:"mixureCode"`
			Irraigated       string `json:"irraigated"`
			Unirrigated      string `json:"unirrigated"`
			ConstituentCrops struct {
				CropName    string `json:"cropName"`
				Irraigated  string `json:"irraigated"`
				Unirrigated string `json:"unirrigated"`
			}
		}
		PureCropArea struct {
			PureCropName string `json:"pureCropName"`
			Irraigated   string `json:"irraigated"`
			Unirrigated  string `json:"unirrigated"`
		}
	}
	UncultivableLand struct {
		Nature string `json:"nature"`
		Area   string `json:"area"`
	}
	IrrigationSource string `json:"irrigationSource"`
	Ramrks           string `json:"remark"`
}

// Verify Maharashtra Form XII
func (formXII MaharashtraFormXII) Verify(villageUID string) (bool, string) {
	return true, villageUID + formXII.SurveyNo + formXII.GatNo
}
