# build my own Iosevka font in ec2
## motivation
하루의 대부분을 코드와 함께하는 입장에서 코딩용 폰트는 저한테 많이 중요한 편입니다.
이쁜 폰트들을 보면 기부니가 많이 좋아집니다. 여러 코딩용 폰트를 사용해봤지만 Iosevka 만한게 없는 것 같습니다.

- 세로로 길쭉하고 가로로는 촘촘한 게 가장 맘에 듭니다.
- 커스터마이징을 지원하는 것도 맘에 듭니다.

기본 Iosevka만으로는 저의 예민한 미적기준을 충족시켜줄 수 없었습니다. 

- width를 최대한 줄이고
- terminal에서 이쁘게 사용할 수 있게 fixed font로 설정하고
- 살짝 밋밋할 수 있는 기본 Iosevka에서 IBM Plex Mono Stylistic을 킥으로 추가한

폰트가 저에게는 STATE-OF-ART 폰트인 것을 알게됬습니다. 

하지만 m2 macbook(16GB)기준으로 iosevka custom font를 빌드하는 데 30분정도 cpu와 memory 사용률이 100%가 찍히며 다른 작업들을 못하는 상황이 발생했습니다.

"그냥 성능 좋은 ec2 인스턴스를 잠깐 빌려서 빌드를 해버리자." 라는 생각을 하게 되었습니다.

## overall process
1. cloudformation으로 ec2생성
2. ec2에 docker 설치
3. ec2에서 Iosevka docker image build
4. Iosevka docker image로 custom font build

이런 과정으로 ec2에서 Iosevka custom font를 빌드합니다.


