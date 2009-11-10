From: "Majed B." <majedb@gmail.com>
Subject: Re: need help: corrupt files on one of my raids
Date: Tue, 10 Nov 2009 21:26:50 +0300
Message-ID: <70ed7c3e0911101026k5e7ba489s6f3e492acc568d2f@mail.gmail.com>
References: <4AF97388.5080907@langseid.no> <70ed7c3e0911100734m31cd846t9987d6141d2513a6@mail.gmail.com>
	<4AF99159.4000800@langseid.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF99159.4000800@langseid.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Either your motherboard doesn't support SMART or worse, your disks
don't support SMART.

I have a bunch if Hitachi disks that don't support SMART, which is
very bad since I can't monitor their health status.

Download the disk's manual and check if it has S.M.A.R.T. capabilities
in it. To read more & understand what S.M.A.R.T. is, check this:
http://en.wikipedia.org/wiki/S.M.A.R.T.

While I was searching for your disk model, I noticed a couple of links
complaining from disk failures. I didn't see whether the disk itself
has SMART or not.

You might want to check your motherboard's manual for SMART support as =
well.

P.S.: Use reply-all ;)

On Tue, Nov 10, 2009 at 7:14 PM, Arild Langseid <arild@langseid.no> wro=
te:
> Hi Majed!
>
> Thank you for your time to help me. I have als=C3=A5 been thinking of=
 hardware
> fault.
>
> I installed smartmontools, but unfortunaly I god this result:
>
> creator:~# smartctl -a /dev/sdb
> smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce =
Allen
> Home page is http://smartmontools.sourceforge.net/
>
> Device: ATA =C2=A0 =C2=A0 =C2=A0Hitachi HDT72101 Version: ST6O
> Serial number: =C2=A0 =C2=A0 =C2=A0 STF604MH0K4X0B
> Device type: disk
> Local Time is: Tue Nov 10 17:43:32 2009 CET
> Device does not support SMART
>
> Error Counter logging not supported
>
> [GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S=
 on']
> Device does not support Self Test logging
> creator:~#
>
>
> Is "smart" something I has to enable?
>
> I have checked my bios, and did not find anything regarding smart the=
re.
>
> Best Regards,
> Arild
>
>
>
> Majed B. wrote:
>>
>> If you have smartmontools installed, run smartctl -a /dev/sdx
>>
>> Look for any number that is bigger than 1 on these:
>> Reallocated_Event_Count
>> Current_Pending_Sector
>> Offline_Uncorrectable
>> UDMA_CRC_Error_Count
>> Raw_Read_Error_Rate
>> Reallocated_Sector_Ct
>> Load_Retry_Count
>>
>> You may not have some of these. That's OK.
>>
>> If you don't have the package, install it, configure it to run short
>> tests daily & long tests on weekends (on idle times).
>> To run an immediate long test, issue this command: smartctl -t offli=
ne
>> /dev/sdx
>>
>> Note: An offline test is a long test and may take up to 20 hours. An
>> offline test is required to get the numbers for the parameters above=
=2E
>>
>> If you're using ext3 filesystem, it would have automatically checked
>> for bad sectors on the time of formatting the volume.
>>
>> I would also suggest you run a fsck on your filesystems.
>>
>> On Tue, Nov 10, 2009 at 5:07 PM, Arild Langseid <arild@langseid.no> =
wrote:
>>>
>>> Hi all!
>>>
>>> I have a strange problem with corrupted files on my raid1 volume. (=
A
>>> raid5
>>> volume on the same computer works just fine).
>>>
>>> One of my raids (md1) is a raid1 with two 1TB sata drives.
>>> I am running lvm on the raid and have two of the volumes on the rai=
d are:
>>> /dev/vg0sata/lv0_bilderArchive
>>> /dev/vg0sata/lv0_bilderProjects
>>> (For your info: "bilder" in Norwegian is "pictures" in english)
>>>
>>> What I want:
>>> I want to use the lv0_bilderArchive to store my pictures unmodified=
 and
>>> lv0_bilderProjects to hold my edited pictures and projects.
>>>
>>> My problem is:
>>>
>>> My files are corrupted. Usually the files (crw/cr2/jpg) are stored =
ok,
>>> but
>>> is corrupted later when new files/directories is added to the volum=
e.
>>> Sometimes the files are corrupted instantly at save-time.
>>>
>>> I discovered this first when copying from my laptop to the server v=
ia
>>> samba.
>>> By testing I have found that this behavour also applies when I copy=
 local
>>> on
>>> the server from raid5 (md0) to the faulty raid1(md1) with cp -a.
>>>
>>> I have tested with both reiserfs and ext3 filesystem. The file-corr=
uption
>>> happens on both reiserfs and ext3.
>>>
>>> One of my test-procedures was as follows:
>>> 1. copied 21 pictures localy to the root of the lv0_bilderProjects
>>> volume.
>>> First 10 pictures, then 11 more by cp -a. All pictures survived and=
 was
>>> stored non-corrupted.
>>> 2. Then I copied a whole directory-tree with cp -a to the
>>> lv0_bilderProjects
>>> volume. Many pictures was corrupted, a few stored ok. All small
>>> text-files
>>> with exif-info seems ok. All files on the volume-root copied in 1) =
is ok.
>>> 3. Then I copied one more directory-tree. All pictures seems ok. Mo=
stly
>>> jpg
>>> this time.
>>> 4. Then I copied one more directory-tree, larger this time. Now the=
 first
>>> 21
>>> pictures in the volume-root is corrupted. All of them - and some of=
 them
>>> in
>>> a way that my browser can't show them at all but shows an error-mes=
sage.
>>>
>>> I think by my test that the samba, network and type of filesystem i=
s not
>>> the
>>> source to my problems.
>>>
>>> I have the same problem on all lvm-volumes on the raid in question =
(md1).
>>>
>>> What's common and what's different on my to raids:
>>>
>>> differences on the two raid-systems:
>>> md0 (working correct) is a raid5, three ide-disks, 200GB each.
>>> md1 (corrupted files) is a raid1, two sata-disks, 1TB each.
>>>
>>> common:
>>> I use lvm on both raid-devices to host my filesystems.
>>>
>>> other useful information:
>>> I use Debian:
>>> creator:~# cat /proc/version
>>> Linux version 2.6.18-6-686 (Debian 2.6.18.dfsg.1-26etch1)
>>> (dannf@debian.org)
>>> (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP =
Thu
>>> Nov 5
>>> 16:28:13 UTC 2009
>>>
>>> I have run apt-get update and apt-get upgrade, and all seems to be
>>> updated.
>>>
>>> The sata disks are hosted on the motherboard: ABit NF7
>>> The disks hosting the raid I have trouble with (md1) are Hitachi
>>> Deskstar 1TB 16MB SATA2 7200RPM, 0A38016
>>>
>>> The output from mdadm --detail /dev/md1 and cat /proc/mdstat seems =
ok,
>>> but I
>>> can post the results here at request. The same applies to the outpu=
t from
>>> pvdisplay, vgdisplay and lvdisplay. They seems ok, but I can post a=
t
>>> request.
>>>
>>> Due to the time to build a 1TB raid I have not tried to use the dis=
ks in
>>> md1
>>> without raiding them. Is it a good idea to tear the raid down and t=
est
>>> the
>>> disks directly or does any of you have other ideas to test before I=
 take
>>> this time consuming action?
>>>
>>>
>>> Any ideas out there? Links to information I should read?
>>>
>>> Thank heaven for my backup-routines including all copy on cold
>>> harddrives both in my safe and off location :-D
>>>
>>> Thanks for all help!
>>>
>>> Best Regards,
>>> Arild, Oslo, Norway
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>>
>>
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
