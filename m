From: Sam Bingner <sam@bingner.com>
Subject: Re: reiserfsck Segfaulting om md readonly raid6 array, dmesg shows
 "kernel BUG at drivers/md/md.c:5790"
Date: Tue, 2 Apr 2013 05:35:52 +0000
Message-ID: <690BA797-78CE-4DFE-B246-B38AD301455F@bingner.com>
References: <20130401172929.W24136@tmp.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130401172929.W24136@tmp.com.br>
Content-Language: en-US
Content-ID: <75DBC1858A7AD94D90F19D6194CDD90F@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Durval Menezes <durval.menezes@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Apr 1, 2013, at 10:26 AM, Durval Menezes <durval.menezes@gmail.com> wrote:

> Hello folks,
> 
> First a little background: I'm in the process of recovering a 5-disk RAID6
> array where 3 devices failed :-/ What happened is that one device died,
> then we inserted a new device and during rebuild two others were kicked
> from the array, separated by a few minutes, due to them having bad sectors
> too and taking too long to return failure to md (TLER was not set). This
> was on a EL4-based system running kernel 2.6.27.
> 
> I've rebooted from a recovery CD (gentoo mini with kernel  2.6.29), then
> managed to reassemble the array with the two intact disks and one of the
> kicked-out ones. I then set it to readonly (md --readonly   /dev/md0) for
> safety while checking everything out, and then checked it with vgscan,
> which found all three LVM volumes (good sign, and IMO demonstrates that my
> data could have survived). Then I set those volumes active (with vgchange
> -a y) and tried to run "reiserfsck --check" on the first of them, with the
> following result:
> 
>     reiserfsck --check /dev/VolGroup00/Main
>         [...]
>         Replaying journal..
>         Trans replayed: mountid 47, transid 11403219, desc 197, len 1, commit 199, next trans offset 182
>         Segmentation fault
> 
> I then checked dmesg and got the "kernel BUG at drivers/md/md.c" message
> block copied below.
> 
> I wonder whether this is related to the fsync bug on md0 arrays recently
> reported here on the list (it makes sense for reiserfsck to call fsync
> after each critical recovery point, even though not much sense if the
> filesystem is in read-only mode... but anyway IMHO the request should have
> been just ignored).
> 
> Also, what would you suggest in order to recover from this? Should I just
> reset the array to readwrite mode and hope for the best? Hope I don't need
> a new kernel for recovery, because it will not be viable to upgrade to a
> more recent kernel, nor change from reiserfs to something else in the
> middle of this (specially in the middle recovering my data).
> 
> Thanks in advance,
> -- 
>   Durval.

I would suggest making a snapshot of your filesystem and running the fsck on that.  If it screws up you can delete the snapshot and try something else without having corrupted your data.  

Sam