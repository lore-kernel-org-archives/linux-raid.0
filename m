From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid5 two disk temp failure
Date: Sat, 14 Aug 2004 12:54:37 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16669.32493.775346.885436@cse.unsw.edu.au>
References: <20040813134051.B3328@tictactoe.unixboxen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Richard Massa on Friday August 13
To: Richard Massa <ramassa@ucdavis.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 13, ramassa@ucdavis.edu wrote:
> Hi all,
> 
> I've got a 6 disk raid5 array that just failed because some little elf loosened the cable going 
> to two of the disks in a scsi enclosure.  Both of them got kicked.
> 
> Using mdadm -a /dev/md2 gives a segfault in both versions 1.6.0 and
> 1.7.0.

Odd.  I doesn't when I try it.
If you can get it to drop a core (ulimit -c unlimited), and then get a
stack trace:
    gdb `which mdadm` core
    where

That might help.
However "mdadm -a /dev/md2" is a no-op.  Is there a typo?

> 
> I can query the array using mdadm just fine, the output is attached. 
> 
> Anyone know what is going on?  I can attach a strace if that
> helps...

If you loose two drives, raid5 cannot cope. However if you are sure
that the data on the drives is still good (as seems likely in this
case) you can re-assemble the array with
   mdadm --assemble /dev/md2 --force /dev/sd[abcdef]1

and it will be assembled with one missing drive which you then might
need to add in.

NeilBrown
