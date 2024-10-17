#!/bin/bash
#################################################
# Yazan		: Yahya YILDIRIM 
# E-Posta	: yahya.yldrm@gmail.com	
# Web		: https://github.com/yahyayildirim/
# Bu script kişisel kullanım için oluşturulmuştur.
# Lütfen emeğe saygı gösterin, kullanacak ve
# paylaşacaksanız github adresimi kaynak olarak gösterin.
#################################################

if [[ "$(whoami)" != root ]]; then
	exec sudo -- "$0" "$@"
fi


gri=$'\e[1;30m';
kirmizi=$'\e[1;31m';
yesil=$'\e[1;32m';
sari=$'\e[1;33m';
mavi=$'\e[1;34m';
mor=$'\e[1;35m';
turkuaz=$'\e[1;36m';
banner=$'\e[5m';
sifirla=$'\e[0m';
kalin=$'\e[1m';
baslik="${kirmizi}###  \e[4mBELGENET E-İMZA KURULUM SCRİPTİNE HOŞ GELDİNİZ  ###${sifirla}\n"
clear

tarih(){
    date '+%d-%m-%Y %H:%M:%S'
}

echo -e $baslik

echo "$(tarih) >>> ${mor}DEPOLAR GÜNCELLENİYOR...LÜTFEN BEKLEYİN...${sifirla}"
apt update
clear
echo -e $baslik

echo "$(tarih) >>> ${turkuaz}PROGRAMLAR VE BAĞIMLILIKLAR KONTROL EDİLİYOR...${sifirla}"

eimza_applet() {
	opt=`echo ${opt} | awk -F'%20|/' '{ print $1 }'`
	echo -e "\n$(tarih) >>> ${kirmizi}$opt sürümü indiriliyor... Bu biraz zaman alabilir lütfen bekleyin...${sifirla}"

	if ! [ -f /tmp/"${opt}".zip ]; then
		if [[ "${opt}" == "1.0.49" ]]; then
			curl -# -o /tmp/"${opt}".zip $url"1.0.49%20yeni%20sertifikal%C4%B1/signNativeOsService_Linux_1.0.49_yeni%20sertifikali.zip" -k
		else
			curl -# -o /tmp/"${opt}".zip $url''"$opt"'/'signNativeOsService_Linux_"$opt".zip -k
		fi
	fi
	#wget -q -c -nc $url''$opt'/'signNativeOsService_Linux_$opt.zip &&
	sleep 1
	echo "$(tarih) >>> ${mavi}Dosyalar arşivden çıkarılıyor...${sifirla}"; sleep 1
	unzip -q -o /tmp/"${opt}".zip -d /tmp/ 1>/dev/null 2>/dev/null
	echo "$(tarih) >>> ${gri}Dosya izinleri değiştiriliyor....${sifirla}"; sleep 1
	cd /tmp/signNativeOsService/bin/systemctl/ && chmod -R +x ./* 1>/dev/null 2>/dev/null
	echo "$(tarih) >>> ${kirmizi}Eski belgenet e-imza servisi siliniyor....${sifirla}"; sleep 1
	cd /tmp/signNativeOsService/bin/systemctl/ && ./uninstall.sh 1>/dev/null 2>/dev/null
	sleep 1
	echo "$(tarih) >>> ${mavi}Yeni belgenet e-imza servisi kuruluyor...${sifirla}"; sleep 1
	cd /tmp/signNativeOsService/bin/systemctl/ && ./install.sh 1>/dev/null 2>/dev/null
	sleep 1
	echo "$(tarih) >>> ${sari}Belgenet servisi aktif ediliyor...${sifirla}"; sleep 3
	systemctl enable turksat-imza.service
	systemctl restart turksat-imza.service
	sleep 4
	if [[ ${opt} == "1.0.44" ]]; then
		rm -rf /usr/lib/libeTPKCS11.so
	else
		sudo ln -sfr /usr/lib/libeToken.so /usr/lib/libeTPKCS11.so	
	fi
	echo "$(tarih) >>> ${yesil}Kurulum başarılı bir şekilde tamamlandı...${sifirla}"; sleep 1
	echo "$(tarih) >>> ${kalin}CTRL tuşuna basılı tutun ve fare ile ${banner}>>>${sifirla} ${kirmizi}https://localhost:9001 ${banner}<<<${sifirla} ${kalin}tıklayın...${sifirla}"
}

eguven_src() {
	if [ $(apt list --installed 2>/dev/null | grep ^safenetauthenticationclient | wc -l) -lt 1 ]; then
		echo "$(tarih) >>> ${kirmizi}safenetauthenticationclient sistemizde kurulu olmadığı tespit edildi...${sifirla}"; sleep 1
		echo "$(tarih) >>> ${yesil}safenetauthenticationclient (10.7.77) indiriliyor...(Lütfen bekleyin)${sifirla}";sleep 1
        if [ $(apt list --installed 2>/dev/null | grep ^libssl1.1 | wc -l) -lt 1 ]; then
            curl -# -o /tmp/libssl.deb http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1-1ubuntu2.1~18.04.20_amd64.deb -k
            #curl -# -o /tmp/libssl.deb http://depo.pardus.org.tr/guvenlik/pool/main/o/openssl/openssl_1.1.1n-0%2Bdeb11u3_amd64.deb -k
            apt install -f /tmp/libssl.deb -yy 1>/dev/null 2>/dev/null
        fi
		if ! [ -f /tmp/safenet.zip ]; then
            curl -# -o /tmp/safenet.zip https://www.globalsign.com/en/safenet-drivers/USB/10.7/Safenet_Linux_Installer_DEB_x64.zip -k
		fi
		echo "$(tarih) >>> ${mavi}safenetauthenticationclient (10.7.77) arşivden çıkarılıyor...${sifirla}"; sleep 1
		unzip -q -o /tmp/safenet.zip -d /tmp/ 1>/dev/null 2>/dev/null
		echo "$(tarih) >>> ${gri}safenetauthenticationclient (10.7.77) kuruluyor....${sifirla}"; sleep 1
        apt install -f -yy 1>/dev/null 2>/dev/null
		apt install -f /tmp/safenetauthenticationclient_10.7.77_amd64.deb -yy 1>/dev/null 2>/dev/null
	else
		echo "$(tarih) >>> ${yesil}safenetauthenticationclient sisteminizde kurulu.${sifirla}"; sleep 1
	fi
}

tubitak_src() {
	if [ $(apt list --installed 2>/dev/null| grep ^akis | wc -l) -lt 1 ]; then
		echo "$(tarih) >>> ${kirmizi}HATA!! akis sürücüsünün sistemizde kurulu olmadığı tespit edildi...${sifirla}"; sleep 1
        if [ $(apt list --all-versions akis 2>/dev/null| grep ^akis | wc -l) -lt 1 ]; then
			echo "$(tarih) >>> ${kirmizi}Tubitak Akis E-imza Sürücüsü depoda bulunmadığı için sitesinden indiriliyor...${sifirla}"; sleep 1
			if ! [ -f /tmp/akis.tar ]; then
				curl -# -o /tmp/akis.tar https://kamusm.bilgem.tubitak.gov.tr/islemler/surucu_yukleme_servisi/suruculer/AkisKart/linux/akis_2.0_amd64.tar -k
			fi
			echo "$(tarih) >>> ${yesil}Tubitak Akis E-İmza Sürücüsü arşivden çıkarılıyor...${sifirla}"; sleep 1
			tar -xvf /tmp/akis.tar -C /tmp/ 1>/dev/null 2>/dev/null
			echo "$(tarih) >>> ${yesil}Tubitak Akis E-İmza Sürücüsü kuruluyor....${sifirla}"; sleep 3
            apt install -f -yy 1>/dev/null 2>/dev/null
			apt install /tmp/akis_2.0_amd64.deb -yy 1>/dev/null 2>/dev/null
			echo "$(tarih) >>> ${yesil}Tubitak Akis E-İmza başarılı bir şekilde kuruldu...${sifirla}"
		else
			echo "$(tarih) >>> ${yesil}Depoda akis $(apt-cache policy akis | grep -e "Aday:" | cut -d ":" -f 2 | cut -d " " -f 4) sürümü olduğu tespit edildi...${sifirla}"
			echo "$(tarih) >>> ${yesil}Tubitak Akis E-İmza Sürücüsü kuruluyor...${sifirla}"; sleep 3
			apt install akis -y 1>/dev/null 2>/dev/null
			echo "$(tarih) >>> ${yesil}Tubitak Akis E-İmza Sürücüsü başarılı bir şekilde kuruldu...${sifirla}"
		fi
	else
		echo "$(tarih) >>> ${yesil}akis sürücüleri sisteminizde kurulu${sifirla}"; sleep 1
	fi
}

set curl wget unzip
for A; do
	which "$A" >/dev/null 2>&1 && {
		echo -e "$(tarih) >>> ${yesil}$A sisteminizde kurulu${sifirla}"; sleep 1
	} || {
		echo -e "$(tarih) >>> ${kirmizi}HATA!! $A programının sisteminizde kurulu olmadığı tespit edildi...${sifirla}"; sleep 1
		echo "$(tarih) >>> ${kirmizi}$A için depo kontrol ediliyor...${sifirla}"

		apt-cache search ^$A$ 1>/dev/null 2>/dev/null
		if [ $? -ne 0 ]; then
			echo "$(tarih) >>> ${kirmizi}$A depoda bulunmadı. Programı internetten bulup kurmanız gerekiyor...${sifirla}"; sleep 1
			echo "$(tarih) >>> ${yesil}Kuruluma devam ediliyor...${sifirla}"; sleep 1

		else
			echo "$(tarih) >>> ${yesil}Depoda $A $(apt-cache policy $A | grep -e "Aday:" | cut -d ":" -f 2 | cut -d " " -f 4) sürümü olduğu tespit edildi...${sifirla}"
			echo "$(tarih) >>> ${yesil}$A kuruluyor...${sifirla}"; sleep 3
			apt install $A -y 1>/dev/null 2>/dev/null
			echo "$(tarih) >>> ${yesil}$A başarılı bir şekilde kuruldu...${sifirla}"
		fi

	}
done

tubitak_src
#eguven_src

jdk_version() {
	local result
	local java_cmd
	if [[ -n $(type -p java) ]]; then
		java_cmd=java
	elif [[ (-n "$JAVA_HOME") && (-x "$JAVA_HOME/bin/java") ]]; then
		java_cmd="$JAVA_HOME/bin/java"
	fi
	local IFS=$'\n'
	# remove \r for Cygwin
	local lines=$("$java_cmd" -Xms32M -Xmx32M -version 2>&1 | tr '\r' '\n')
	if [[ -z $java_cmd ]]; then
		result=no_java
	else
		for line in $lines; do
			if [[ (-z $result) && ($line = *"version \""*) ]]; then
				local ver=$(echo $line | sed -e 's/.*version "\(.*\)"\(.*\)/\1/; 1q')
				# on macOS, sed doesn't support '?'
				if [[ $ver = "1."* ]]; then
					result=$(echo $ver | sed -e 's/1\.\([0-9]*\)\(.*\)/\1/; 1q')
				else
					result=$(echo $ver | sed -e 's/\([0-9]*\)\(.*\)/\1/; 1q')
				fi
			fi
		done
	fi
	echo "$result"
}


java_indir() {
	echo -e "\n$(tarih) >>> ${yesil}Java ($java_sec) sürümü kuruluyor... Bu biraz zaman alabilir lütfen bekleyin...${sifirla}"; sleep 1
	apt install $java_sec -y 1>/dev/null 2>/dev/null
	update-alternatives --remove-all java 1>/dev/null 2>/dev/null
	update-alternatives --install /usr/bin/java java /usr/lib/jvm/oracle-java8-jdk-amd64/jre/bin/java 9999
	if [ $? -ne 0 ]; then
		echo "$(tarih) >>> ${kirmizi}Kurulum başarısız oldu...${sifirla}"; sleep 1
	else
		echo "$(tarih) >>> ${yesil}Java ($java_sec) sürümü başarılı bir şekilde kuruldu.${sifirla}"; sleep 1
	fi
}


java_ver="$(jdk_version)"
if [[ $java_ver -ne "8" ]]; then
	echo "$(tarih) >>> ${kirmizi}HATA!! Java'nın sisteminizde kurulu olmadığı tespit edildi.${sifirla}"; sleep 1
	echo -e "\n${kirmizi}###  DEPODA BULUNAN JAVA SÜRÜMLERİ:${sifirla}"

	jre_ver1=($(apt-cache search "oracle-java8-jre$"))
	jdk_ver1=($(apt-cache search "oracle-java8-jdk$"))	
	#jre_ver2=($(apt-cache search "openjdk-[0-9]-jre$"))
	#jre_ver3=($(apt-cache search "openjdk-[0-9]+[0-9]-jre$"))
	#jdk_ver2=($(apt-cache search "openjdk-[0-9]-jdk$"))
	#jdk_ver3=($(apt-cache search "openjdk-[0-9]+[0-9]-jdk$"))


	PS3="
${kalin}Kurmak istediğiniz sürümün sıra numarasını yazın ve ENTER tuşuna basın:${sifirla} "
	select java_sec in ${jre_ver1} ${jdk_ver1} #${jre_ver2} ${jre_ver3} ${jdk_ver2} ${jdk_ver3}
	do
		if [ "$java_sec" == ${java_sec[*]} ]; then
			java_indir
			break
		else
			echo -e "${kirmizi}HATA!!!${sifirla} ${turkuaz}Hatalı seçim yaptınız. Lütfen kurmak istediğiniz sürümün sıra numarasını girerek ENTER tuşuna basın.${sifirla}"
			break
		fi
	done

else
	echo -e "$(tarih) >>> ${yesil}Java'nın $java_ver sürümü sisteminizde kurulu${sifirla}"; sleep 1
fi

echo "$(tarih) >>> ${turkuaz}Sürüm numaraları${sifirla} ${kalin}www.belgenet.com.tr${sifirla} ${turkuaz}adresinden getiriliyor.${sifirla}"; sleep 1
echo "$(tarih) >>> ${gri}İnternet hızınıza göre biraz zaman alabilir, Lütfen bekleyin...${sifirla}"; sleep 1

curl -sL https://localhost:9001 -k > /dev/null
if [ $? == "0" ]; then
    version=$(curl -sL https://localhost:9001 -k | grep "Version" | awk -F " " '{ print $3 }')
else
    version="Yüklü değil"
fi

url="https://www.belgenet.com.tr/statics/BelgenetImzaServisiKurulumDosyalari/Linux/"
wget -q -c -O /tmp/index.html $url --no-check-certificate

if [ $? -ne 0 ]; then
	echo -e "$(tarih) >>> ${kalin}Belgenet web sitesine erişilemiyor... Sunucularda problem olabilir veya internetiniz yok.${sifirla}"; sleep 1
	exit 2
fi

declare -a eimza_vers
echo -e "\n${kirmizi}###  BELGENET E-İMZA SERVİSİ SÜRÜMLERİ:${sifirla}"

while read -r line
do
	#eimza_vers+=($(echo "$line" | sed -n '/\([0-9]\+\.\)/p' | awk -F'"' '{ print $2 }' | awk -F'/' '{ print $1 }'))
	eimza_vers+=($(echo "$line" | sed -n '/\([0-9]\+\.\)/p' | awk -F'"' '{ print $2 }' | awk -F'%20|/' '{ print $1 }'))
done < /tmp/index.html

PS3="
${kalin}Sisteminizde Kurulu Olan Belgenet Servis Sürümü: ${banner}${yesil}${version}${sifirla}
${kalin}Lütfen kurmak istediğiniz sürümü seçin ${kirmizi}(1-${#eimza_vers[*]})${sifirla}${kalin} ve ENTER tuşuna basın:${sifirla} "
select opt in ${eimza_vers[*]}
do
	if [ "$opt" == ${opt[*]} ]; then
		eimza_applet
		break
	else
		echo -e "${kirmizi}HATA!!!${sifirla} ${turkuaz}Lütfen (1-${#eimza_vers[*]}) arası bir rakam girerek ENTER tuşuna basın.${sifirla}"
		break
	fi
done
