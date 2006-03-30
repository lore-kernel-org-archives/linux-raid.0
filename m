From: mitchell laks <mlaks2000@yahoo.com>
Subject: Re: sata controllers status=0x51 =?utf-8?b?ew==?= DriveReady SeekComplete Error =?utf-8?b?fQ==?= error=0x84 =?utf-8?b?ew==?= DriveStatusError BadCRC =?utf-8?b?fQ==?=
Date: Thu, 30 Mar 2006 23:07:00 +0000 (UTC)
Message-ID: <loom.20060331T005324-626@post.gmane.org>
References: <200603301051.31551.mlaks@verizon.net> <442C14A8.4030606@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david <at> dgreaves.com> writes:

> 
> Check out the linux-ide archive for my (and others) reports.

I just read them and weeped.

> 
> I've had lots of issues like this - spurious and IMHO incorrect error
> messages. Only certain types of disk access cause them - xfs_repair and
> rsync seem to tickle it.

Interesting. rsync for me.

> With 2.6.15 I had lots of *very* scary moments with multiple disk
> failures on a raid5 during xfs_repair.
> I think it's down to the 'basic' error handling in the libata code and
> certain disks/controllers being loose with the protocol. They then
> identified problems in 'fua' (IIRC) handling which was pulled for 2.6.16.
> 
> 2.6.16 seems to be much better (fewer 'odd' errors reported and md
> doesn't mind)

"Fewer" - oh oh. Can you quantify this for me? I seem to be getting around 
8-9 /10 days = or averaging about 1 per rsync. 

I should check to see if the distribution is Poisson like distribution :).

I have not lost my raid1 yet. lucky me.

I am now very worried.

I need to do some testing off line with the new kernel  before 
putting out the fix. 

Is your experience also with an Asus board with a via vt8237 powered
 sata  connector?

Would you suggest I try the promise sata connector instead, before 
I try to move
over to the newer kernel? Or both? 
Could you give me more of your experience?

Thanks,

Mitchell

Thanks


