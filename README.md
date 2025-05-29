# mov_prv_off
Windows 탐색기는 크고 많은 `mov` 및 `ts` 파일이 들어있는 폴더를 열 때 매우 느려집니다. 이는 `mov`와 `ts` 파일들에 대해 미리보기를 만들기 때문입니다.   
이 레포지토리의 PowerShell 스크립트를 실행하시면 `mov` 및 `ts` 파일에 대해 미리보기를 만들지 않게 하여 문제를 해결할 수 있습니다.   
[Sendust](https://github.com/sendust)님의 [블로그 글](https://blog.naver.com/sendust/222957359683)을 참고하여 스크립트를 작성하였으며, 
[AveYo](https://github.com/AveYo)님의 [RunAsTI](https://github.com/AveYo/LeanAndMean) 레포지토리 안의 [reg_own.ps1](https://github.com/AveYo/LeanAndMean/blob/main/reg_own.ps1) 덕분에 만들 수 있었습니다.

Windows Explorer gets extremely slow if there are heavy `mov` and `ts` and ts files inside a directory since Explorer tries to make all the previews of them.   
This repo contains a PowerShell script which solves this problem by disabling it.
I appreciate [AveYo](https://github.com/AveYo) for his/her [RunAsTI](https://github.com/AveYo/LeanAndMean) project.
Without his/her [reg_own.ps1](https://github.com/AveYo/LeanAndMean/blob/main/reg_own.ps1), I could not have done this.
