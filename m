From: "Majed B." <majedb@gmail.com>
Subject: Re: can mdadm use /dev/sgX as devices?
Date: Sun, 10 Oct 2010 11:44:33 +0300
Message-ID: <AANLkTin61-5Hxwjyw9Djasem+F3kJOo-_x0tVw4LR+EC@mail.gmail.com>
References: <201010091822.33148.harry.mangalam@uci.edu> <AANLkTi=Db5tgu1D4jjBeKyNTPrBPpkn4gN0J=oPJqLwd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Db5tgu1D4jjBeKyNTPrBPpkn4gN0J=oPJqLwd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Check this post:
http://www.linuxquestions.org/questions/linux-software-2/raid-5-array-n=
ot-assembling-all-3-devices-on-boot-using-mdadm-one-is-degraded-829541/=
#post4085382

On Sun, Oct 10, 2010 at 11:41 AM, Majed B. <majedb@gmail.com> wrote:
>
> Hello,
> Check this post:=C2=A0http://www.linuxquestions.org/questions/linux-s=
oftware-2/raid-5-array-not-assembling-all-3-devices-on-boot-using-mdadm=
-one-is-degraded-829541/#post4085382
>
> On Sun, Oct 10, 2010 at 4:22 AM, Harry Mangalam <harry.mangalam@uci.e=
du> wrote:
>>
>> the short version:
>> =C2=A0Can mdadm use /dev/sgX as devices?
>> =C2=A0(and if so, how?)
>>
>> the longer version is:
>>
>> I inherited a 6-bay IBM x3655 =C2=A0with a ServeRAID-8k RAID control=
ler
>> (from docs, it seems to be an 8-port Adaptec 9580W SAS/SATA
>> controller). I'd like to run Ubuntu 10.04.
>>
>> I can use the controller BIOS on boot to config and set up a RAID5
>> (which presents to the OS as '/dev/sda' - the 'very large device'.
>> However there's no way to add notification of disk failure. =C2=A0Th=
ere are
>> some GUI Java-based packages which claim to be able to do this (a
>> 32bit Java RaidManager (RaidMan), which seems to be a re-badged
>> Adaptec StorageManager (StorMan - also available in a true 64bit
>> version) which I've managed to get running but they both lock up in
>> various ugly and opaque ways.
>>
>> Along with the Java GUI apps is an Adaptec commandline app called
>> 'arcconf' that allows you to peek at the controller and does allow a
>> primitive amount of control (but not email notification of disk
>> failure).
>>
>> I'd prefer to use mdadm since it's simpler and mostly 'just works an=
d
>> does email notifications. However, the controller does not translate
>> the /dev/sgX addresses to the /dev/sdX devices that mdadm seems to
>> want.
>>
>> - lspci says:
>> =C2=A005:00.0 RAID bus controller: Adaptec AAC-RAID (Rocket) (rev 02=
)
>>
>> - The boot process does not load the aacraid driver, but it can be
>> modprobed manually. =C2=A0This doesn't change much tho:
>>
>> # lsmod |grep aacraid
>> aacraid =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A076291=
 =C2=A00
>>
>>
>> - dmesg shows:
>> [ =C2=A0 =C2=A03.394749] scsi 0:1:0:0: Attached scsi generic sg1 typ=
e 0
>> [ =C2=A0 =C2=A03.394877] scsi 0:1:1:0: Attached scsi generic sg2 typ=
e 0
>> [ =C2=A0 =C2=A03.394981] scsi 0:1:2:0: Attached scsi generic sg3 typ=
e 0
>> [ =C2=A0 =C2=A03.395085] scsi 0:1:3:0: Attached scsi generic sg4 typ=
e 0
>> [ =C2=A0 =C2=A03.395190] scsi 0:1:4:0: Attached scsi generic sg5 typ=
e 0
>> [ =C2=A0 =C2=A03.395296] scsi 0:1:5:0: Attached scsi generic sg6 typ=
e 0
>> [ =C2=A0 =C2=A03.395427] scsi 0:3:0:0: Attached scsi generic sg7 typ=
e 13
>> (The last is the controller)
>>
>> - # sg_scan shows
>> /dev/sg0: scsi1 channel=3D0 id=3D0 lun=3D0 [em]
>> /dev/sg1: scsi0 channel=3D1 id=3D0 lun=3D0 [em]
>> /dev/sg2: scsi0 channel=3D1 id=3D1 lun=3D0 [em]
>> /dev/sg3: scsi0 channel=3D1 id=3D2 lun=3D0 [em]
>> /dev/sg4: scsi0 channel=3D1 id=3D3 lun=3D0 [em]
>> /dev/sg5: scsi0 channel=3D1 id=3D4 lun=3D0 [em]
>> /dev/sg6: scsi0 channel=3D1 id=3D5 lun=3D0 [em]
>> /dev/sg7: scsi0 channel=3D3 id=3D0 lun=3D0 [em]
>> /dev/sg8: scsi2 channel=3D0 id=3D0 lun=3D0 [em]
>> /dev/sg9: scsi7 channel=3D0 id=3D0 lun=3D0 [em]
>>
>> # sg_map
>> /dev/sg0 =C2=A0/dev/scd0 <- cdrom
>> /dev/sg1 =C2=A0 =C2=A0 < no /dev/sdX mapping
>> /dev/sg2
>> /dev/sg3
>> /dev/sg4
>> /dev/sg5
>> /dev/sg6
>> /dev/sg7 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 <- controller
>> /dev/sg8 =C2=A0/dev/sda <- broadcom severworks SATA disk
>> /dev/sg9 =C2=A0/dev/sdb <- USB thumbdrive
>>
>> --
>> Harry Mangalam - Research Computing, NACS, Rm 225 MSTB, UC Irvine
>> [ZOT 2225] / 92697 =C2=A0949 824-0084(o), 949 285-4487(c)
>> MSTB=3DBldg 415 (G-5 on <http://today.uci.edu/pdf/UCI_09_map_campus.=
pdf>
>> --
>> Non-sarcarstic use of 'seamless' in any context having to do with
>> computers immediately disqualifies the speaker as an expert.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
>
> --
> =C2=A0 =C2=A0 =C2=A0=C2=A0 Majed B.



--
=C2=A0 =C2=A0 =C2=A0=C2=A0 Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
