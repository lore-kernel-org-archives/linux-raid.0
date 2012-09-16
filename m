From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Mon, 17 Sep 2012 01:35:31 +0200
Message-ID: <50566243.1080907@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se> <5052E096.5040509@linuxsystems.it> <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com> <20120914182755.GA2534@cthulhu.home.robinhill.me.uk> <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com> <5054D175.5070303@linuxsystems.it> <20120915194102.GA10403@cthulhu.home.robinhill.me.uk> <5055AD0A.60704@linuxsystems.it> <44576376-12B0-4A78-B5CF-C759ED2EBA9A@colorremedies.com> <5055F0CF.6000908@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5055F0CF.6000908@linuxsystems.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I finally managed to reallocate the sectors!

I tried with sg3-utils but I get:

root@asterisk:~# sg_reassign --address=3D3912 /dev/sda
REASSIGN BLOCKS not supported

then I read this on the smartmontools mailing list:

<<
Possibly what is happening is that because he is only writing a partial
block, the OS is first trying to read the the original block so that it
can preserve the parts that won't be changing. When this operation fail=
s,
it blocks the write that would trigger reallocation of the bad sector.
Writing using the OS blocksize (typically 4096 on linux systems) proper=
ly
aligned should work around that issue.
 >>

so I tried with

dd if=3D/dev/zero of=3D/dev/sda bs=3D4096

and ta-daaa! :D

197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s=20
       -       *0*
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age=20
Offline      -       1


Current_Pending_Sector are gone!


with a smartctl -t offline /dev/sda I removed the Offline_Uncorrectable=
 too:

197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s=20
       -       0
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age=20
Offline      -       *0*




=46or the sake of google:

     Reallocated_Event_Count

     This is how many sectors have already been reallocated on the=20
drive. We're hoping to get the hard disk to increase this number!

     Current_Pending_Sector

     The number of sectors that the drive thinks are dodgy. Bear in min=
d=20
sometimes drives change their mind about whether a sector is bad or not=
=20
- so this number can go down without a reallocation occuring.

     Offline_Uncorrectable

     This is the number of sectors that the drive has attempted to=20
correct itself, but failed. Running the command:

     smartctl -t offline /dev/hda

     should cause the drive to test the sectors and attempt to fix them=
=2E=20
Not all drives support this though.




Thanks for helping!
Niccol=F2
--=20
http://www.linuxsystems.it
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
