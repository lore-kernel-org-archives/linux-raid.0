From: Gordon Henderson <gordon@drogon.net>
Subject: Re: EVMS or md?
Date: Mon, 4 Apr 2005 23:52:23 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0504042336500.21243@lion.drogon.net>
References: <200504040708.j3478bm03863@www.watkins-home.com>
 <1112642928.25469.28.camel@dyn95395156> <200504041446.50337.kewley@gps.caltech.edu>
 <d2seal$ntf$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d2seal$ntf$1@terminus.zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 4 Apr 2005, H. Peter Anvin wrote:

> I can't speak for the EVMS people, but I got to stress-test my RAID6
> test system some this weekend; after having run in 1-disk degraded
> mode for several months (thus showing that the big bad "degraded
> write" bug has been thoroughly fixed) I changed the motherboard, and
> the kernel didn't support one of the controllers.  And now there were
> 2 missing drives.  Due to some bootloader problems, I ended up
> yo-yoing between the two kernels a bit more than I intended to, and
> went through quite a few RAID disk losses and rebuilds as a result.

I bit the bullet recently and moved a raft of servers over to 2.6.11 and
RAID-6. Biggest single partition is 1.3TB over 8 drives. Oddest is
probably 4 drives in a RAID-6 setup, but hey ... (All are running Debian
Woody FWIW)

So-far so good. No crashes, no failures. Performance is adequate (Mix of
Opteron and Hyperthreading Xeon processors, SCSI and SATA drives, Gb
Ether) and I'm hoping they'll stay that way for the next 3 years until
they are replaced.

6 years ago, I built mt first (Linux S/W) RAID-5 system... (and that
server was only retired last year) Lets hope RAID-6 does just as good a
job!

Gordon
