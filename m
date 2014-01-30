From: Chris Murphy <lists@colorremedies.com>
Subject: Re: [HELP] Recover a RAID5 with 8 drives
Date: Thu, 30 Jan 2014 14:48:32 -0700
Message-ID: <A8650C09-BAC4-43D8-8BBA-024E6E295D1E@colorremedies.com>
References: <52E7CCE4.3030408@morganspa.com> <A2EC67620EC7424F9EC3DD49243E9060466D9512@AUDIINSX0328.audi.vwg> <52E90CA9.5070808@morganspa.com> <A2EC67620EC7424F9EC3DD49243E9060466D9B0D@AUDIINSX0328.audi.vwg>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2EC67620EC7424F9EC3DD49243E9060466D9B0D@AUDIINSX0328.audi.vwg>
Sender: linux-raid-owner@vger.kernel.org
To: "Samer, Michael (I/ET-83, extern)" <extern.michael.samer@audi.de>
Cc: 'Maurizio De Santis' <m.desantis@morganspa.com>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 30, 2014, at 5:20 AM, "Samer, Michael (I/ET-83, extern)" <extern=
=2Emichael.samer@audi.de> wrote:
>=20
>  * reading about TLER I believe I understood that the failing disks
> are not necessarly broken, but the RAID thinks they are; does it mean
>    that I can still use the failing disks?

=46or starters, make sure the SCSI command timer is increased to at lea=
st that of the drive timeout, there's a chance the drive might recover =
data before there's a read error.

echo 120 >/sys/block/sdX/device/timeout

This is per drive kernel setting. So you have to do this for each drive=
=2E It's also not persistent across reboots.

If during your rebuild any two drives report a read error, then it's a =
problem. And the rebuild stops. In this case, you can find the affected=
 drive(s) and sectors causing the read error from dmesg. Then on indivi=
dual physical drives, do sector reads to locate the exact LBAs affected=
=2E If these are AF disks, don't forget for each bad 4096 byte sector, =
you'll get 8 LBA read errors. To fix it, you must write to all 8 LBAs. =
I'd avoid using bs=3D4096 to avoid confusion because that also changes =
any seek=3D value away from 512e based LBAs. Just keep it all 512 secto=
r based, and just know you have to write out a count of at least 8 to f=
ix each physical sector. Before doing this though, I'd report back if y=
ou're getting two UREs on a stripe and the rebuild fails. Someone else =
with more experience may help with which disk to choose.=20

Obviously the above means destroying some data on disk, but it's better=
 to zero a bad sector (which is lost anyway) rather than it producing a=
 URE - this way you only get one URE for that stripe on the next rebuil=
d. What data is corrupted as a result of this depends on what was locat=
ed in those sectors, it has a decent chance of being free space if the =
array isn't full. Next most likely is some file data or metadata. And t=
hen less likely is file system metadata=85 once the rebuild is done, yo=
u'll run an fsck with -n, to see if there are file system problems and =
how major they are. You don't necessarily want to run an fsck that writ=
es changes to the file system as a first step, it could write changes t=
hat hose the fs even though the array rebuild was successful. Anyway, c=
ross that bridge when you come to it, but it's better to work slower an=
d make as few changes as necessary if this is an array that you don't h=
ave a current backup for.

Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
