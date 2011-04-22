From: Seblu <seblu@seblu.net>
Subject: Re: Mdadm, udev and fakeraid?
Date: Fri, 22 Apr 2011 13:24:32 +0200
Message-ID: <BANLkTi=upCBGXGOWK2A4PPGFCCMPrWqY6g@mail.gmail.com>
References: <BANLkTinp3376PV3sJWARXtFnRfoMsg44wA@mail.gmail.com>
 <20110405162008.5f2c48fe@notabene.brown> <BANLkTik+xU6K7B9Xomj6+Q-S7_n18+aQqA@mail.gmail.com>
 <20110418103852.2ead1a69@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110418103852.2ead1a69@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 18, 2011 at 2:38 AM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 15 Apr 2011 16:15:50 +0200 Seblu <seblu@seblu.net> wrote:
>
>> On Tue, Apr 5, 2011 at 8:20 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Sun, 3 Apr 2011 18:03:50 +0200 Seblu <seblu@seblu.net> wrote:
>> >
>> >> Hello,
>> >>
>> >> In the following commit, udev rules load isw_raid (fakeraid). Fro=
m my
>> >> test, this doesnt work. I have to call dmraid to have something
>> >> working.
>> >> http://neil.brown.name/git?p=3Dmdadm;a=3Dcommit;h=3D475a01b8bce85=
75dd1b2ab6495e65e854702ac0e
>> >>
>> >> isw_raid is only fakeraid devices? mdadm is able to mount fakerai=
d partition?
>> >>
>> >
>> > I'm sorry but I cannot parse those questions successfully so I'm n=
ot sure
>> > what you are asking.
>>
>> Hello Neil,
>>
>> in my previous mail, i used word fakeraid about raid created with
>> dmraid and i used softraid about raid created with mdadm. it was not
>> clear.
>>
>> So my question was about compatibily. Raids created by dmraid can be
>> assembled with mdadm and vice versa?
>>
>> > Both dmraid and mdadm can manage some 'fakeraid' arrays. =A0dmraid=
 supports a
>> > wider variety. =A0mdadm supports raid1 and raid5 more completely t=
han dmraid
>> > does.
>> mdadm -> create soft raid for linux =A0(now there is new format: ddf=
 and imsm) ?
>> dmraid -> create soft raid from industry raid card format =A0?
>
> No, it isn't that simple.
>
> dmraid uses the 'dm' kernel module. =A0mdadm uses the 'md' kernel mod=
ule.
>
> As such dmraid doesn't support RAID5 (yet) and doesn't support RAID1 =
very
> well.
> mdadm supports both of these well, but doesn't support the same range=
 of
> "industry raid card formats".
>
> There is a growing amount of overlap.
>
>>
>> > Both should support isw to some degree.
>> > Intel are currently working with mdadm to make it provide full sup=
port for
>> > "IMSM" (Intel Matrix Storage Manager). =A0I don't know the exact r=
elationship
>> > between 'isw' and 'IMSM' - maybe they are different names for the =
same thing.
>> ok
>>
>> > If mdadm doesn't work for your isw arrays, and you want it to, the=
n I suggest
>> > you report details about what is, or is not, happening.
>> My purpose is to improve archlinux startup detection of fakeraids
>> (mdadm + dmraid).
>>
>> With mdadm everything works correctly without call to "mdadm -As"
>> With dmraid, no raid is created by udev rules, so we need to run
>> "dmraid -i -ay" at startup.
>>
>> To test this kind of raid, i created a dmraid array in a vm. This
>> created me a /dev/mapper/isw_bfbjdbadhb_testF device.
>> call blkid on a disk member of this raid tell me this:
>> /dev/sde: TYPE=3D"isw_raid_member"
>> and on "mdadm" created raid:
>> /dev/sdd: UUID=3D"a974b525-993a-1481-f860-6471f3f120e1"
>> UUID_SUB=3D"eb22aee2-b2ee-e56d-1008-44d52c63564d" LABEL=3D"archipel:=
0"
>> TYPE=3D"linux_raid_member"
>>
>> This misled me because mdadm udev rules uses the output of blkid to
>> mount raids which have type "isw_raid_member".
>> What disturbs me is that mdadm cannot mount raid created by dmraid
>> with type isw_raid_member.
>>
>> About outputs:
>> mdadm -I --verbose /dev/sde
>> mdadm: no RAID superblock on /dev/sde.
>
> As has been mentioned elsewhere, mdadm only recognised IMSM arrays on
> machines with IMSM hardware. =A0I'm not entirely happy about this and=
 may well
> change it.
>
>
>>
>> # mdadm --examine /dev/sde
>> /dev/sde:
>> =A0 =A0 =A0 =A0 =A0 Magic : Intel Raid ISM Cfg Sig.
>> =A0 =A0 =A0 =A0 Version : 1.1.00
>> =A0 =A0 Orig Family : 5a8ed623
>> =A0 =A0 =A0 =A0 =A0Family : 5a8ed623
>> =A0 =A0 =A0Generation : 00000000
>> =A0 =A0 =A0 =A0 =A0 =A0UUID : ae2e9cd8:7fa43248:47c694a1:24990cbc
>> =A0 =A0 =A0 =A0Checksum : c23b6c88 correct
>> =A0 =A0 MPB Sectors : 1
>> =A0 =A0 =A0 =A0 =A0 Disks : 2
>> =A0 =A0RAID Devices : 1
>>
>> =A0 Disk00 Serial : 66faec8-9f5b237d
>> =A0 =A0 =A0 =A0 =A0 State : active
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0Id : 00040000
>> =A0 =A0 Usable Size : 1019486 (497.88 MiB 521.98 MB)
>>
>> [testF]:
>> =A0 =A0 =A0 =A0 =A0 =A0UUID : 6640a4cc:5faa1ce3:c1bff2b3:1093ca7d
>> =A0 =A0 =A0RAID Level : 1
>> =A0 =A0 =A0 =A0 Members : 2
>> =A0 =A0 =A0 =A0 =A0 Slots : [UU]
>> =A0 =A0 Failed disk : none
>> =A0 =A0 =A0 This Slot : 0
>> =A0 =A0 =A0Array Size : 1014446 (495.42 MiB 519.40 MB)
>> =A0 =A0Per Dev Size : 1014792 (495.59 MiB 519.57 MB)
>> =A0 Sector Offset : 0
>> =A0 =A0 Num Stripes : 3963
>> =A0 =A0 =A0Chunk Size : 64 KiB
>> =A0 =A0 =A0 =A0Reserved : 0
>> =A0 Migrate State : idle
>> =A0 =A0 =A0 Map State : normal
>> =A0 =A0 Dirty State : clean
>>
>> =A0 Disk01 Serial : 0b540c6-4e527908
>> =A0 =A0 =A0 =A0 =A0 State : active
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0Id : 00050000
>> =A0 =A0 Usable Size : 1019486 (497.88 MiB 521.98 MB)
>>
>>
>> Do not you think that dmraid should also ship an udev rules file to
>> mount the raid which can handle?
>
> I have no opinion about what dmraid should do. =A0I have enough troub=
le working
> out what mdadm should do :-)
>
Thanks Neil, it's more clear.

Regards,

--=20
S=E9bastien Luttringer
www.seblu.net
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
