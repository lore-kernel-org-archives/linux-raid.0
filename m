From: Marc MERLIN <marc@merlins.org>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl
 can't be used?
Date: Fri, 4 Nov 2016 12:51:27 -0700
Message-ID: <20161104195127.ymenm7ezmhscbzn6@merlins.org>
References: <20161030093337.GA3627@metamorpher.de>
 <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de>
 <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
 <20161030171234.GD28648@merlins.org>
 <20161030171654.GE28648@merlins.org>
 <20161104181808.lplrtmafwlub3ck4@merlins.org>
 <90cf5c8f-fcd3-d510-7f6e-6be6ade3969f@turmel.org>
 <20161104185040.yrznk3j4rvtwsxbk@merlins.org>
 <20161104235917.2d6d0fcc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161104235917.2d6d0fcc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Phil Turmel <philip@turmel.org>, Neil Brown <neilb@suse.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 04, 2016 at 11:59:17PM +0500, Roman Mamedov wrote:
> On Fri, 4 Nov 2016 11:50:40 -0700
> Marc MERLIN <marc@merlins.org> wrote:
> 
> > I can switch to GiB if you'd like, same thing:
> > myth:/dev# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8190
> > dd: reading `/dev/md5': Invalid argument
> > 2+0 records in
> > 2+0 records out
> > 2147483648 bytes (2.1 GB) copied, 21.9751 s, 97.7 MB/s
> 
> But now you cansee the cutoff point is exactly at 8192 -- a strangely familiar
> number, much more so than "8.8 TB", right? :D
 
Yes, that's a valid point :)

> Could you recheck (and post) your mdadm --detail /dev/md5, if the whole array
> didn't get cut to a half of its size in "Array Size".

I just posted it in my previous Email:
myth:~# mdadm --query --detail /dev/md5

/dev/md5:
        Version : 1.2
  Creation Time : Tue Jan 21 10:35:52 2014
     Raid Level : raid5
     Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
  Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Oct 31 07:56:07 2016
          State : clean

(more in the previous Email)

> Or maybe the remove bad block list code has some overflow bug which cuts each
> device size to 2048 GiB, without the array size reflecting that. You run RAID5
> of five members, (5-1)*2048 would give you exactly 8192 GiB.

that's very possible too.
So even though the array is marked clean and I don't care if some md
blocks return data that is actually corrupt as long as the read succeeds
(my filesystem will sort that out), I figured I could try a repair.

What's interesting is that it started exactly at 50%, which is also
likely where my reads were failing.

myth:/sys/block/md5/md# echo repair > sync_action 

md5 : active raid5 sdg1[0] sdd1[5] sde1[3] sdf1[2] sdh1[6]
      15627542528 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
      [==========>..........]  resync = 50.0% (1953925916/3906885632) finish=1899.1min speed=17138K/sec
      bitmap: 0/30 pages [0KB], 65536KB chunk

That said, as this resync is processing, I'd think/hope it would move
the error forward, but it does not seem to:
myth:/sys/block/md5/md# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8190
dd: reading `/dev/md5': Invalid argument
2+0 records in
2+0 records out
2147483648 bytes (2.1 GB) copied, 27.8491 s, 77.1 MB/s

So basically I'm stuck in the same place, and it seems that I've found
an actual swraid bug in the kernel and I'm not hopeful that the problem
will be fixed after the resync completes.

If someone wants me to try stuff before I wipe it all and restart, let
me know, but otherwise I've been in this broken state for 3 weeks now
and I need to fix it so that I can restart my backups again.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
