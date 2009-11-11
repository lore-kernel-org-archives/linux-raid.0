From: "Majed B." <majedb@gmail.com>
Subject: Re: need help: corrupt files on one of my raids
Date: Wed, 11 Nov 2009 05:29:25 +0300
Message-ID: <70ed7c3e0911101829x48e6eb68o892ef11b2ff2d19@mail.gmail.com>
References: <4AF97388.5080907@langseid.no> <70ed7c3e0911100734m31cd846t9987d6141d2513a6@mail.gmail.com>
	<4AF99159.4000800@langseid.no> <70ed7c3e0911101026k5e7ba489s6f3e492acc568d2f@mail.gmail.com>
	<4AF9CB19.7000803@langseid.no> <70ed7c3e0911101231r9e7e8b0nfcd94a60e5635831@mail.gmail.com>
	<4AF9D194.6000306@langseid.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF9D194.6000306@langseid.no>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If you have no data on the volumes, would you mind formatting the
volumes with a different filesystem? ext3/ext4/xfs and see if you
still get data corruption.

On Tue, Nov 10, 2009 at 11:48 PM, Arild Langseid <arild@langseid.no> wr=
ote:
> Yes I have run a fsck:
>
> ###########
> reiserfsck --check started at Tue Nov 10 22:15:27 2009
> ###########
> Replaying journal..
> Reiserfs journal '/dev/mapper/vg0sata-lv0_multimedia' in blocks [18..=
8211]:
> 0 transactions replayed
> Checking internal tree..finished
> Comparing bitmaps..finished
> Checking Semantic tree:
> finished
> No corruptions found
> There are on the filesystem:
> =C2=A0 =C2=A0 =C2=A0 Leaves 82
> =C2=A0 =C2=A0 =C2=A0 Internal nodes 1
> =C2=A0 =C2=A0 =C2=A0 Directories 7
> =C2=A0 =C2=A0 =C2=A0 Other files 101
> =C2=A0 =C2=A0 =C2=A0 Data block pointers 77964 (0 of them are zero)
> =C2=A0 =C2=A0 =C2=A0 Safe links 0
> ###########
> reiserfsck finished at Tue Nov 10 22:15:29 2009
> ###########
>
> Seems ok to me.
>
> I will now run the offline checks you suggested earlier.
>
> As it is not very clear that I have a raid problem as I first thought=
=2E... is
> there any other mailing list I should ask about my problem, or is it =
ok to
> continue here?
>
> Best Regards,
> Arild
>
> Majed B. wrote:
>>
>> The numbers will be reported as zeros if you have never run an offli=
ne
>> test before. Run it and then you'll get to see whether you have bad
>> sectors or not.
>>
>> Have you tried running a filesystem check? (fsck)
>>
>> On Tue, Nov 10, 2009 at 11:20 PM, Arild Langseid <arild@langseid.no>
>> wrote:
>>
>>>
>>> Hi and thanks again!
>>>
>>> I did not find the feature-list for my disk either. Instead I found=
 my
>>> smartmontools to be very old.
>>> I upgraded my Debian Etch to Debian Lenny (took some time....), and=
 now
>>> the
>>> smartctl works. I got lucky about the smart feature on my disks and
>>> motherboard.
>>>
>>> Output for /dev/sdb:
>>> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x000b =C2=A0 100 =C2=A0 =
100 =C2=A0 016 =C2=A0 =C2=A0Pre-fail =C2=A0Always
>>> =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 005 =C2=A0 =C2=A0Pre-fail =C2=A0Always
>>> =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>> 196 Reallocated_Event_Count 0x0032 =C2=A0 100 =C2=A0 100 =C2=A0 000=
 =C2=A0 =C2=A0Old_age =C2=A0 Always
>>> =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>> 197 Current_Pending_Sector =C2=A00x0022 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
>>> =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>> 198 Offline_Uncorrectable =C2=A0 0x0008 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
>>> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x000a =C2=A0 200 =C2=A0 200 =
=C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
>>> =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>>
>>> SMART Error Log Version: 1
>>> No Errors Logged
>>>
>>> and /dev/sdc:
>>> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x000b =C2=A0 100 =C2=A0 =
100 =C2=A0 016 =C2=A0 =C2=A0Pre-fail =C2=A0Always
>>> =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 100 =C2=A0 100 =C2=
=A0 005 =C2=A0 =C2=A0Pre-fail =C2=A0Always
>>> =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>> 196 Reallocated_Event_Count 0x0032 =C2=A0 100 =C2=A0 100 =C2=A0 000=
 =C2=A0 =C2=A0Old_age =C2=A0 Always
>>> =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>> 197 Current_Pending_Sector =C2=A00x0022 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
>>> =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>> 198 Offline_Uncorrectable =C2=A0 0x0008 =C2=A0 100 =C2=A0 100 =C2=A0=
 000 =C2=A0 =C2=A0Old_age =C2=A0 Offline
>>> =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>>> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x000a =C2=A0 200 =C2=A0 200 =
=C2=A0 000 =C2=A0 =C2=A0Old_age =C2=A0 Always
>>> =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>>>
>>> SMART Error Log Version: 1
>>> No Errors Logged
>>>
>>> Seems ok to me. Do you agree?
>>>
>>> After upgrading to Debian Lenny - I still got corrupted files thoug=
h :(
>>>
>>> Best Regards,
>>> Arild
--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
