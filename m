From: Sebastian Utz <su@rotamente.com>
Subject: Re: Software RAID-5 attempt to access beyond end of device...
Date: Fri, 27 Aug 2004 20:20:42 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1093630841.13975.146.camel@slurp>
References: <1093621033.13979.49.camel@slurp>
	 <Pine.LNX.4.56.0408271739470.23465@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0408271739470.23465@lion.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2004-08-27 at 18:41, Gordon Henderson wrote:
> On Fri, 27 Aug 2004, Sebastian Utz wrote:
> 
> > Hello,
> >
> > I have a problem with an Software RAID-5 at the top of 4 IDE-Drives
> > connected via 2 Promise UltraTX2 (20268) IDE controller.
> >
> > FS is EXT3.
> > Kernel 2.6.8.1	(problem occured with 2.6.7, update didn't helped)
> > CPU: Pentium II 400
> > Mainboard: Asus P2B-S
> >
> > After 29% usage, I've got an Kernel oops and system stalls:
> > -------- snip start -------------
> > Aug 27 16:30:18 gharb kernel: attempt to access beyond end of device
> > Aug 27 16:30:18 gharb kernel: md0: rw=1, want=6917529027856096120,
> > limit=241215360
> 
> I've seen something like this with a corrupt ext2 filesystem. Not had it
> panic the box though, but a reboot into maintanance mode, and manual fsck
> might be wise...
> 
> Gordon

As I write I using an ext3 FS and I also tried doing an manually fsck,
but than the kernel hangs with an different oops..
sorry I didn't mentioned this..
I also read at the inet, somebody have had the same problem a few times
ago:
http://marc.theaimsgroup.com/?l=linux-raid&m=107087900802777&w=2
http://marc.theaimsgroup.com/?l=linux-raid&m=107134150812889&w=2

but thanks for the hint!
sebastian

