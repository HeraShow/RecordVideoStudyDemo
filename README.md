# RecordVideoStudyDemo
## 短视频录制
- UIPickerImageController
- AVCaptureFileOutput
- AVAssetWriter

### UIPickerImageController

只能设置一些简单参数，例如界面上的操作按钮，还有视频的画质等，自定义程度不高。

### AVCaptureFileOutput

* 数据采集在AVCaptureSession中进行，只需要一个输出即可，指定一个文件路后，视频和音频会写入到指定路径，不需要其他复杂的操作。

* 系统已经把数据写到文件中了，剪裁视频需要从文件中读到一个完整的视频，然后处理。

### AVAssetWriter

* 数据采集在AVCaptureSession中进行，需要 AVCaptureVideoDataOutput 和 AVCaptureAudioDataOutput两个单独的输出，拿到各自的输出数据后，然后自己进行相应的处理。

* 拿到的数据流，还没有合成视频，对数据流进行处理，可以配置更多的参数。
