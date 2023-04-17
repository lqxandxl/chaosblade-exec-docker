package exec

import (
	"fmt"
	"github.com/chaosblade-io/chaosblade-spec-go/spec"
	"github.com/chaosblade-io/chaosblade-spec-go/util"
	"github.com/lqxandxl/chaosblade-exec-docker/version"
	"github.com/sirupsen/logrus"
	"path"
)

var JvmSpecFileForYaml = ""

// 通过解析chaosblade-exec-jvm生成的yaml文件来获取一组命令
// getJvmModels returns java experiment specs
func getJvmModels() []spec.ExpModelCommandSpec {
	logrus.Infof("default parse java yaml and path is: %s", util.GetYamlHome())
	var jvmSpecFile = path.Join(util.GetYamlHome(), fmt.Sprintf("chaosblade-jvm-spec-%s.yaml", version.BladeVersion))
	if JvmSpecFileForYaml != "" {
		//如果用户有指定传入文件，那么使用用户指定的文件
		jvmSpecFile = JvmSpecFileForYaml
	}
	modelCommandSpecs := make([]spec.ExpModelCommandSpec, 0)
	models, err := util.ParseSpecsToModel(jvmSpecFile, nil)
	if err != nil {
		logrus.Infof("parse java spec failed, so skip it, %s", err)
		return modelCommandSpecs
	}
	for idx := range models.Models {
		modelCommandSpecs = append(modelCommandSpecs, &models.Models[idx])
	}
	return modelCommandSpecs
}
