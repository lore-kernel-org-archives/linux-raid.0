From: Neil Brown <neilb@suse.de>
Subject: Re: Weird blocks at fsync() calls using md
Date: Fri, 28 Jul 2006 21:11:35 +1000
Message-ID: <17609.61671.113267.692986@cse.unsw.edu.au>
References: <20060728101645.GA32686@freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sander Smeenk on Friday July 28
Sender: linux-raid-owner@vger.kernel.org
To: Sander Smeenk <ssmeenk@freshdot.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 28, ssmeenk@freshdot.net wrote:
> Hello list,
> 
> I've recently subscribed to this list as i'm facing a little problem
> using md v0.90.3 (bitmap v4.39) on Linux 2.6.17.1, Debian 'sid', mdadm
> 2.4.1...

sounds fairly up-to-date.

> 
> While the system is under heavy disk IO, calls to fsync() made by vim
> (for example) block for a LONG time. Like 30 seconds or more. I'm not
> sure if it also blocks other IO during that fsync() wait, but it's nasty
> enough to have your :w action take 30+ secs...

I have vim taking forever to ":w" without using md/raid at all - I
suspect vim does something silly (maybe a 'sync' instead of just an
'fsync' - haven't bothered to check yet).

Precisely what evidence do you have?

> 
> My system is running in RAID1 on two SCSI U320 disks:
> Personalities : [raid1] 
> md0 : active raid1 sdb[0] sdc[1]
>       71819392 blocks [2/2] [UU]

Looks perfectly normal.

> 
> Some guy on IRC told me he had the same problem once, and it was related
> to some whacky locking mechanism used in the software raid code? I'd
> really like to know if this is a common problem and what i can do about
> it.

I don't think md uses any whacky locking mechanisms...

If you want to help solve it (which would be great) the best thing is
to collect some concrete data.
e.g.
  strace -o /tmp/trace -tt -p pid-of-vim

while doing the thing in vim that takes a long time.

NeilBrown
