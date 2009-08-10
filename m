From: Daniel Iliev <daniel.iliev@gmail.com>
Subject: Re: raid10 problem with spare disk
Date: Mon, 10 Aug 2009 10:14:57 +0300
Message-ID: <20090810101457.0390d92a.daniel.iliev@gmail.com>
References: <1249755852.5095.86.camel@ilievnet.com>
	<20b671d0bba986ff7c119757440a8c26.squirrel@neil.brown.name>
	<20090809105534.8cb0e649.daniel.iliev@gmail.com>
	<4340507aed0605af55fbaf1f9f694cfb.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 9 Aug 2009 20:43:34 +1000 (EST)
"NeilBrown" <neilb@suse.de> wrote:
> 
> The remaining drives: sdb and sdd, are slot '0' and '1' though I suspect
> you expected them to be '1' and '3'.
> As they are 0 and 1, they don't provide all of the data.
> You need to figure out which slot sdc3 used to occupy and recreate
> the array using 'missing' for the fourth drive and '--assume-clean'
> to avoid resync.
>  e.g. mdadm -S /dev/md2
>       mdadm --create /dev/md2 --level 10 --layout f2 --assume-clean \
>                 /dev/sdb3 /dev/sdd3 missing /dev/sdc3
> That is assuming that you figure out that sdc3 was slot '3' (counting
> from 0).
> 
> The only way I can think of to find out where sdc3 was slot 2 or
> slot 3 is to try each of them and then run a 'check' and see what
> the mismatch count is.
> 
> So run the above --create command, but don't fsck or mount or anything
> else to the device.
> Then    echo check > /sys/block/md2/md/sync_action
> and watch the value of
>             /sys/block/md2/md/mismatch_cnt
> 
> if that keeps getting big, the we picked the wrong slot.
> If it stays fairly small (maybe a few hundred) then we probably got the
> right slot.
> To try the other arrangement, use the same command except for the last
> two words which should be swapped:   /dev/sdc3 missing
> 
> Once you have the array working again with 3 disks, choose a disk
> to remove that will leave the array still functional.  For a 4 disk
> raid10 in f2, you need either both even devices (0 and 2) or both
> odd devices (1 and 3).
> 
> Then continue with your original plan.
> --re-add should work if you have picked the right drive and have a
> bitmap.
> 
> 
> Good luck.
> 
> NeilBrown
> 

It worked. BIG THANKS!

The working combination was:

mdadm --create /dev/md2 --level 10 --layout f2 -c 4096 --assume-clean \
--raid-devices 4 /dev/sdb3 /dev/sdd3 missing /dev/sdc3 


-- 
 <daniel.iliev@gmail.com>

