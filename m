From: Bernd Schubert <Bernd.Schubert@tc.pci.uni-heidelberg.de>
Subject: Re: Tyan, RAID-6, and other recent hassles... (long, a bit OT)
Date: Sun, 20 Feb 2005 00:02:58 +0100
Message-ID: <20050219230258.GA21802@fubini.pci.uni-heidelberg.de>
References: <Pine.LNX.4.56.0502170923200.819@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.56.0502170923200.819@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
Cc: techsupport@tyan.com, support@tyan.de
List-Id: linux-raid.ids

Hi,

> Mobo was a Tyan Thunder K8W. (S2885)

personally I'm very disappointed about Tyan, well I only know their
opteron mainboards, but thats already sufficient to never buy their
mainboards again.

Server B (failover): S2880, as soon as a cable is plugged in into one of
the onboard broadcom NICs, the system crashes. Broadcom driver doesn't
need to be loaded, system may already crash during the pre-boot
initialisation or later on during the kernel boot-procedure.

Server A (main): First S2882 board crashed rather soon during pre-boot
initialisation, in the bios setup, during the boot-procedure and
sometimes it was even running stable - for a few hours. After returning
the server, we got back the system with a new mainboard (if it only
hadn't taken them two month to do this :-( ). 
With the new mainboard it was running stable for about 7 month and, we only 
experienced some rather strange ext2 errors. Interesting also to note
that those ext2 partitions were mirrored by drbd and those errors could
not be observed on the corresponding partions on Server B.
After exchanging one of the software components that required ext2, we 
could get completely rid of those ext2 partitions and everything was
fine until 1.5 weeks ago. The server suddenly crashed and crashed again
shortly after rebooting. Reiserfsck found pretty much problems on the
root partions and we decided to use our backup. For some reasons we are
pretty convinced that those ext2 and reiserfs errors are due to the
onbaord SIL3114 controller (its probably not RAM, since we monitor the
ECC memory using bluesmoke, futhermore, the much bigger data partitions
connected to the onboard SCSI controller are (so far) not affected by any
of those problems) . We now added an additional promise controller. 
Unfortunately this didn't solve our crash problem. After updating the
bios to the recent version, the promise bios complained that it can't
find any harddisk, downgrading to the version from last July solved this
problem and also almost our crash problem (bevor updating the bios was
from last March or April). It now only crashes sometimes during the bios
initialisation...

Cluster, 16 nodes: S2881 boards, master server crashed rather often
until we updated to linux-2.6.9 (old kernel was 2.4.27).


Cheers,
	Bernd


PS: I'm also mailling this to Tyan. I'm curious what they will say about
this report.
