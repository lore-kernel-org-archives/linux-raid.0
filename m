From: Mark Knecht <markknecht@gmail.com>
Subject: Re: q: RAID1 with very unbalanced disk performance
Date: Tue, 6 Apr 2010 09:31:29 -0700
Message-ID: <o2n5bdc1c8b1004060931y29a1171ci45dd28cc735fdfb6@mail.gmail.com>
References: <4BBB5303.1090001@artefact.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BBB5303.1090001@artefact.nl>
Sender: linux-raid-owner@vger.kernel.org
To: olaf@artefact.nl
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 6, 2010 at 8:28 AM, Olaf Zevenboom <olaf@artefact.nl> wrote=
:
> Dear List,
>
> We have a setup with two SATA2 1.5 TB harddisks in MD/LVM2 RAID1 setu=
p on
> Debian Lenny stock kernel.
> As it is suffering from performance troubles I did take a closer look=
 and
> noticed that /dev/sda is way more intensively used than /dev/sdb. I
> monitored the drives with various tools including atop.
> /dev/sda is always a bit busier than /dev/sdb. This behavior can also=
 be
> seen on other systems with a similar setup (Etch and Lenny), but on t=
his
> particular system /dev/sda is about 10% more intensively used. Althou=
gh I
> think that is quite a lot and not as it should be I can live with tha=
t. What
> worries me more is that /dev/sda can peek upto 100% disk-utilization =
causing
> the system to be temporary unresponsive whilest /dev/sdb does not see=
m to
> peek over 20% or so.
> Any pointers on what is happening here and/or how I can resolve this =
issue
> are quite welcome.
>
> Thanking you in advance,
> Olaf Zevenboom
>
> Details:
>
> Running Debian Lenny with stock kernel 2.6.26-2-amd64 #1 SMP
> LVM2 on top of MD
>
> 2 SATA2 1.5tb disks: lsscsi
> [0:0:0:0] =C2=A0 =C2=A0disk =C2=A0 =C2=A0ATA =C2=A0 =C2=A0 =C2=A0WDC =
WD15EARS-00Z 80.0 =C2=A0/dev/sda
> [1:0:0:0] =C2=A0 =C2=A0disk =C2=A0 =C2=A0ATA =C2=A0 =C2=A0 =C2=A0ST31=
500541AS =C2=A0 =C2=A0 CC32 =C2=A0/dev/sdb
>
> cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sda2[0] sdb2[1]
> =C2=A0 =C2=A0 1464886912 blocks [2/2] [UU]
> =C2=A0 =C2=A0md0 : active raid1 sda1[0] sdb1[1]
> =C2=A0 =C2=A0 248896 blocks [2/2] [UU]
> =C2=A0 =C2=A0unused devices: <none>
>
> hdparm -tT /dev/sda
>
> /dev/sda:
> Timing cached reads: =C2=A0 2890 MB in =C2=A02.00 seconds =3D 1445.36=
 MB/sec
> Timing buffered disk reads: =C2=A0300 MB in =C2=A03.01 seconds =3D =C2=
=A099.67 MB/sec
>
> hdparm -tT /dev/sdb
>
> /dev/sdb:
> Timing cached reads: =C2=A0 7482 MB in =C2=A02.00 seconds =3D 3743.83=
 MB/sec
> Timing buffered disk reads: =C2=A0302 MB in =C2=A03.02 seconds =3D 10=
0.00 MB/sec
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

I suspect it's not 'sda' as much as it is the WD15EARS itself that's ma=
king sda.

I purchased 6 WD10EARS drives and they simply didn't work for RAID,
but even in single drive situations I see stuff going on with them I
don't understand. One clue is that smartctl tells me the
LOAD_CYCLE_COUNT is increasing at a rate of 30/hour and I haven't
found out why. At that rate the drive is out of spec in 18 months, not
3 years, and I've seen this on two different machines. I saw problems
in dmesg and /var/log/messages about reads and writes being blocked
and once in awhile a kernel warning with trace back about a drive
timing out.

On the other hand I replaced the 1TB WD10EARS with a Raid Edition
500GB WD drive - WD5002ABYS - and I see none of these problems. My
RAID1 setup is working great. I have no error or warning messages
anywhere that I can find. Granted, half the storage for $10 more per
drive, but it WORKS!

Just my observations so far.

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
