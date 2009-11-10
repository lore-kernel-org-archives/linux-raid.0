From: "Majed B." <majedb@gmail.com>
Subject: Re: need help: corrupt files on one of my raids
Date: Tue, 10 Nov 2009 23:31:47 +0300
Message-ID: <70ed7c3e0911101231r9e7e8b0nfcd94a60e5635831@mail.gmail.com>
References: <4AF97388.5080907@langseid.no> <70ed7c3e0911100734m31cd846t9987d6141d2513a6@mail.gmail.com>
	<4AF99159.4000800@langseid.no> <70ed7c3e0911101026k5e7ba489s6f3e492acc568d2f@mail.gmail.com>
	<4AF9CB19.7000803@langseid.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF9CB19.7000803@langseid.no>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The numbers will be reported as zeros if you have never run an offline
test before. Run it and then you'll get to see whether you have bad
sectors or not.

Have you tried running a filesystem check? (fsck)

On Tue, Nov 10, 2009 at 11:20 PM, Arild Langseid <arild@langseid.no> wr=
ote:
> Hi and thanks again!
>
> I did not find the feature-list for my disk either. Instead I found m=
y
> smartmontools to be very old.
> I upgraded my Debian Etch to Debian Lenny (took some time....), and n=
ow the
> smartctl works. I got lucky about the smart feature on my disks and
> motherboard.
>
> Output for /dev/sdb:
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x000b =C2=A0 100 =C2=A0 10=
0 =C2=A0 016 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 005 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 196 Reallocated_Event_Count 0x0032 =C2=A0 100 =C2=A0 100 =C2=A0 000 =C2=
=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 197 Current_Pending_Sector =C2=A00x0022 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 198 Offline_Uncorrectable =C2=A0 0x0008 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
> =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x000a =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>
> SMART Error Log Version: 1
> No Errors Logged
>
> and /dev/sdc:
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x000b =C2=A0 100 =C2=A0 10=
0 =C2=A0 016 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 005 =C2=A0 =C2=A0Pre-fail =C2=A0Always
> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 196 Reallocated_Event_Count 0x0032 =C2=A0 100 =C2=A0 100 =C2=A0 000 =C2=
=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 197 Current_Pending_Sector =C2=A00x0022 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 198 Offline_Uncorrectable =C2=A0 0x0008 =C2=A0 100 =C2=A0 100 =C2=A0 =
000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
> =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x000a =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>
> SMART Error Log Version: 1
> No Errors Logged
>
> Seems ok to me. Do you agree?
>
> After upgrading to Debian Lenny - I still got corrupted files though =
:(
>
> Best Regards,
> Arild
>
>
> Majed B. wrote:
>>
>> Either your motherboard doesn't support SMART or worse, your disks
>> don't support SMART.
>>
>> I have a bunch if Hitachi disks that don't support SMART, which is
>> very bad since I can't monitor their health status.
>>
>> Download the disk's manual and check if it has S.M.A.R.T. capabiliti=
es
>> in it. To read more & understand what S.M.A.R.T. is, check this:
>> http://en.wikipedia.org/wiki/S.M.A.R.T.
>>
>> While I was searching for your disk model, I noticed a couple of lin=
ks
>> complaining from disk failures. I didn't see whether the disk itself
>> has SMART or not.
>>
>> You might want to check your motherboard's manual for SMART support =
as
>> well.
>>
>> P.S.: Use reply-all ;)
>>
>> On Tue, Nov 10, 2009 at 7:14 PM, Arild Langseid <arild@langseid.no> =
wrote:
>>
>>>
>>> Hi Majed!
>>>
>>> Thank you for your time to help me. I have als=C3=A5 been thinking =
of hardware
>>> fault.
>>>
>>> I installed smartmontools, but unfortunaly I god this result:
>>>
>>> creator:~# smartctl -a /dev/sdb
>>> smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruc=
e
>>> Allen
>>> Home page is http://smartmontools.sourceforge.net/
>>>
>>> Device: ATA =C2=A0 =C2=A0 =C2=A0Hitachi HDT72101 Version: ST6O
>>> Serial number: =C2=A0 =C2=A0 =C2=A0 STF604MH0K4X0B
>>> Device type: disk
>>> Local Time is: Tue Nov 10 17:43:32 2009 CET
>>> Device does not support SMART
>>>
>>> Error Counter logging not supported
>>>
>>> [GLTSD (Global Logging Target Save Disable) set. Enable Save with '=
-S
>>> on']
>>> Device does not support Self Test logging
>>> creator:~#
>>>
>>>
>>> Is "smart" something I has to enable?
>>>
>>> I have checked my bios, and did not find anything regarding smart t=
here.
>>>
>>> Best Regards,
>>> Arild
>>>
>>>
>>>
>>> Majed B. wrote:
>>>
>>>>
>>>> If you have smartmontools installed, run smartctl -a /dev/sdx
>>>>
>>>> Look for any number that is bigger than 1 on these:
>>>> Reallocated_Event_Count
>>>> Current_Pending_Sector
>>>> Offline_Uncorrectable
>>>> UDMA_CRC_Error_Count
>>>> Raw_Read_Error_Rate
>>>> Reallocated_Sector_Ct
>>>> Load_Retry_Count
>>>>
>>>> You may not have some of these. That's OK.
>>>>
>>>> If you don't have the package, install it, configure it to run sho=
rt
>>>> tests daily & long tests on weekends (on idle times).
>>>> To run an immediate long test, issue this command: smartctl -t off=
line
>>>> /dev/sdx
>>>>
>>>> Note: An offline test is a long test and may take up to 20 hours. =
An
>>>> offline test is required to get the numbers for the parameters abo=
ve.
>>>>
>>>> If you're using ext3 filesystem, it would have automatically check=
ed
>>>> for bad sectors on the time of formatting the volume.
>>>>
>>>> I would also suggest you run a fsck on your filesystems.
>>>>
>>>> On Tue, Nov 10, 2009 at 5:07 PM, Arild Langseid <arild@langseid.no=
>
>>>> wrote:
>>>>
>>>>>
>>>>> Hi all!
>>>>>
>>>>> I have a strange problem with corrupted files on my raid1 volume.=
 (A
>>>>> raid5
>>>>> volume on the same computer works just fine).
>>>>>
>>>>> One of my raids (md1) is a raid1 with two 1TB sata drives.
>>>>> I am running lvm on the raid and have two of the volumes on the r=
aid
>>>>> are:
>>>>> /dev/vg0sata/lv0_bilderArchive
>>>>> /dev/vg0sata/lv0_bilderProjects
>>>>> (For your info: "bilder" in Norwegian is "pictures" in english)
>>>>>
>>>>> What I want:
>>>>> I want to use the lv0_bilderArchive to store my pictures unmodifi=
ed and
>>>>> lv0_bilderProjects to hold my edited pictures and projects.
>>>>>
>>>>> My problem is:
>>>>>
>>>>> My files are corrupted. Usually the files (crw/cr2/jpg) are store=
d ok,
>>>>> but
>>>>> is corrupted later when new files/directories is added to the vol=
ume.
>>>>> Sometimes the files are corrupted instantly at save-time.
>>>>>
>>>>> I discovered this first when copying from my laptop to the server=
 via
>>>>> samba.
>>>>> By testing I have found that this behavour also applies when I co=
py
>>>>> local
>>>>> on
>>>>> the server from raid5 (md0) to the faulty raid1(md1) with cp -a.
>>>>>
>>>>> I have tested with both reiserfs and ext3 filesystem. The
>>>>> file-corruption
>>>>> happens on both reiserfs and ext3.
>>>>>
>>>>> One of my test-procedures was as follows:
>>>>> 1. copied 21 pictures localy to the root of the lv0_bilderProject=
s
>>>>> volume.
>>>>> First 10 pictures, then 11 more by cp -a. All pictures survived a=
nd was
>>>>> stored non-corrupted.
>>>>> 2. Then I copied a whole directory-tree with cp -a to the
>>>>> lv0_bilderProjects
>>>>> volume. Many pictures was corrupted, a few stored ok. All small
>>>>> text-files
>>>>> with exif-info seems ok. All files on the volume-root copied in 1=
) is
>>>>> ok.
>>>>> 3. Then I copied one more directory-tree. All pictures seems ok. =
Mostly
>>>>> jpg
>>>>> this time.
>>>>> 4. Then I copied one more directory-tree, larger this time. Now t=
he
>>>>> first
>>>>> 21
>>>>> pictures in the volume-root is corrupted. All of them - and some =
of
>>>>> them
>>>>> in
>>>>> a way that my browser can't show them at all but shows an
>>>>> error-message.
>>>>>
>>>>> I think by my test that the samba, network and type of filesystem=
 is
>>>>> not
>>>>> the
>>>>> source to my problems.
>>>>>
>>>>> I have the same problem on all lvm-volumes on the raid in questio=
n
>>>>> (md1).
>>>>>
>>>>> What's common and what's different on my to raids:
>>>>>
>>>>> differences on the two raid-systems:
>>>>> md0 (working correct) is a raid5, three ide-disks, 200GB each.
>>>>> md1 (corrupted files) is a raid1, two sata-disks, 1TB each.
>>>>>
>>>>> common:
>>>>> I use lvm on both raid-devices to host my filesystems.
>>>>>
>>>>> other useful information:
>>>>> I use Debian:
>>>>> creator:~# cat /proc/version
>>>>> Linux version 2.6.18-6-686 (Debian 2.6.18.dfsg.1-26etch1)
>>>>> (dannf@debian.org)
>>>>> (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SM=
P Thu
>>>>> Nov 5
>>>>> 16:28:13 UTC 2009
>>>>>
>>>>> I have run apt-get update and apt-get upgrade, and all seems to b=
e
>>>>> updated.
>>>>>
>>>>> The sata disks are hosted on the motherboard: ABit NF7
>>>>> The disks hosting the raid I have trouble with (md1) are Hitachi
>>>>> Deskstar 1TB 16MB SATA2 7200RPM, 0A38016
>>>>>
>>>>> The output from mdadm --detail /dev/md1 and cat /proc/mdstat seem=
s ok,
>>>>> but I
>>>>> can post the results here at request. The same applies to the out=
put
>>>>> from
>>>>> pvdisplay, vgdisplay and lvdisplay. They seems ok, but I can post=
 at
>>>>> request.
>>>>>
>>>>> Due to the time to build a 1TB raid I have not tried to use the d=
isks
>>>>> in
>>>>> md1
>>>>> without raiding them. Is it a good idea to tear the raid down and=
 test
>>>>> the
>>>>> disks directly or does any of you have other ideas to test before=
 I
>>>>> take
>>>>> this time consuming action?
>>>>>
>>>>>
>>>>> Any ideas out there? Links to information I should read?
>>>>>
>>>>> Thank heaven for my backup-routines including all copy on cold
>>>>> harddrives both in my safe and off location :-D
>>>>>
>>>>> Thanks for all help!
>>>>>
>>>>> Best Regards,
>>>>> Arild, Oslo, Norway
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-inf=
o.html
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>>
>>
>
>
> No virus found in this outgoing message.
> Checked by AVG - www.avg.com
> Version: 8.5.425 / Virus Database: 270.14.59/2494 - Release Date: 11/=
10/09
> 07:38:00
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
