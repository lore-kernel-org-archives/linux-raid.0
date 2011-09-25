From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Green drives and RAID arrays with partity
Date: Sun, 25 Sep 2011 06:43:36 -0500
Message-ID: <4E7F13E8.4080606@hardwarefreak.com>
References: <4E7F0A31.4070001@yazzy.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7F0A31.4070001@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/25/2011 6:02 AM, Marcin M. Jessa wrote:
> Hi guys.
>
> I was wondering if it's safe to use so called green drives in RAID 5 =
or
> RAID 6 with md?
> Drive such as Seagate Barracuda=AE Green 2TB ST2000DL003 or Western
> Digital Caviar=AE Green=99 2TB WD20EARX have TLER off and reading mis=
c
> forums I understand that it would be a good idea to buy drives with t=
hat
> option available.
> On the other hand some people claim that Linux/Solaris/BSD based
> software RAID may be able to work just fine with these drives.

That won't make a lick of difference if you attach them to a crappy=20
HBA/RAID card or mobo down chip, and/or with a buggy driver, or plug=20
them into a crappy backplane.  Note the recent discussion of the=20
SuperMicro/Marvell HBA, mvsas driver problems.

When you have a problem such as yours, and you ask for help on this, or=
=20
any other Linux kernel list, it's a really good idea to post all of the=
=20
relevant information up front.  Why?  Because most often when drives=20
drop out of arrays it is not because a disk failed or the disk has bugg=
y=20
firmware.  It's most often because of problems elsewhere in the storage=
=20
stack, either hardware or software.

Crappy HBAs and/or drivers, loose or dislodged cable connectors, and=20
crappy active/passive backplanes are the primary movers when it comes t=
o=20
good drives dropping out of arrays.

That said, assuming you have a good SAS/SATA ASIC/driver combo and=20
stable backplane, etc, I'd say buy the WD RE4 or Seagate Constellation=20
ES as they have 5 year warranties, TLER, all the good stuff for RAID=20
use.  Which is why they are sold as "enterprise" drives and cost more=20
than consumer cheapos like the various Green "drives".  Both the RE4 2T=
B=20
and Constellation ES 2TB are $200 each at Newegg.  Unless you actually=20
*need* that much total space, I'd go with the 1TB models, paying ~half=20
the cost of the 2TB drives.  The 1TB Constellation ES is $110.  So with=
=20
5 drives you'll save almost $500 on drives, with 4TB usable space with=20
RAID5.

Again, I implore you to investigate all other portions of your storage=20
stack before blowing money on drives, which may not be the cause of you=
r=20
problem.

--=20
Stan


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
