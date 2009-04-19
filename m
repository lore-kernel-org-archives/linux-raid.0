From: Neil Brown <neilb@suse.de>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Mon, 20 Apr 2009 09:27:46 +1000
Message-ID: <18923.45938.499331.641264@notabene.brown>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
	<18922.50050.860008.242658@notabene.brown>
	<20090419225556.GC14157@darkside.22.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mario 'BitKoenig' Holbe on Monday April 20
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 20, Mario.Holbe@TU-Ilmenau.DE wrote:
> On Sun, Apr 19, 2009 at 04:24:02PM +1000, Neil Brown wrote:
> > On Saturday April 18, Mario.Holbe@TU-Ilmenau.DE wrote:
> > > I created a 4.5T RAID10 with internal bitmap out of 3 1.5T disks on a
> > > and I get a strange inconsistency between the on-disk and the in-kernel
> > > bitmap representation:
> > Could you let me know if that following patch helps?
> 
> I attached the patch to 2.6.28 because of the still pending .29-fix.
> It looks better but not perfect, if you ask me:

Thanks for testing.

> 
> root@darkside:~# mdadm -G -b internal /dev/md7
> [  137.605821] md7: bitmap file is out of date (0 < 8382) -- forcing full recovery
> [  137.627777] md7: bitmap file is out of date, doing full recovery
> [  137.871855] md7: bitmap initialized from disk: read 9/9 pages, set 268275 bits
> [  137.893543] created bitmap (131 pages) for device md7
> root@darkside:~# cat /proc/mdstat
> Personalities : [raid1] [raid10]
> md7 : active raid10 sdc1[0] sde1[4] sdd1[2]
>       4395406848 blocks 512K chunks 2 near-copies [6/3] [U_U_U_]
>       bitmap: 0/131 pages [0KB], 16384KB chunk
> ...
> 
> It looks like there are now enough pages allocated in-kernel.
> So - yes, the patch helps :)
> 
> The "read 9/9 pages" message does still look somewhat strange but better
> than before (where it was "read 1/1 pages, set 6131 bits") and it seems
> to be similar to messages of my other raids.
> The "set 268275 bits" message does not seem to be consistent to the
> "bitmap: 0/131 pages [0KB]" mdstat, but this is quite likely unrelated
> to the original problem.

I think this is all consistent, though possibly confusing.
On disk, we use 1 bit per chunk so 268275 chunks uses 33535 bytes or 66
sectors or 9 (4K) pages.

In memory, we use 16 bits per chunk, so we can count how many pending
accesses there are to each chunk and so know when we can clear the
bit.
So 268275 chunks uses 536550 bytes or 523K or 131 (4K) pages.
These pages are only alloced on demand, so when the bitmap is
completely clean, there are likely to be 0 allocated.

> 
> root@darkside:~# mdadm -X /dev/sd[cde]1 | grep Bitmap
>           Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
>           Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
>           Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
> 
> The discrepancy between the "0/131 pages [0KB]" in-kernel and the
> "137203 dirty (51.1%)" on-disk seems to be another, unrelated issue.
> I experienced somehow similar issues when adding a new component to an
> existing bitmapped device. When the full-sync of the new component is
> finished, the bitmap on the new component does usually show still lots
> of dirty bits (sometimes only a few %, sometimes up to 95%) while the
> other devices show 0 dirties. And this doesn't change over time or when
> dropping page caches.

I think that problem is fixed by 
  commit 355a43e641b948a7b755cb4c2466ec548d5b495f

which is in 2.6.29.

NeilBrown
