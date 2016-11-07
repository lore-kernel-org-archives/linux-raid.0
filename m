From: Marc MERLIN <marc@merlins.org>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl
 can't be used?
Date: Sun, 6 Nov 2016 17:13:42 -0800
Message-ID: <20161107011342.fld53ntd3djrctb2@merlins.org>
References: <20161030161929.GA5582@metamorpher.de>
 <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
 <20161030171234.GD28648@merlins.org>
 <20161030171654.GE28648@merlins.org>
 <20161104181808.lplrtmafwlub3ck4@merlins.org>
 <90cf5c8f-fcd3-d510-7f6e-6be6ade3969f@turmel.org>
 <20161104185040.yrznk3j4rvtwsxbk@merlins.org>
 <20161104235917.2d6d0fcc@natsu>
 <20161104195127.ymenm7ezmhscbzn6@merlins.org>
 <87lgwwnnyf.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lgwwnnyf.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Roman Mamedov <rm@romanrm.net>, Phil Turmel <philip@turmel.org>, Neil Brown <neilb@suse.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 07, 2016 at 11:16:56AM +1100, NeilBrown wrote:
> On Sat, Nov 05 2016, Marc MERLIN wrote:
> >
> > What's interesting is that it started exactly at 50%, which is also
> > likely where my reads were failing.
> >
> > myth:/sys/block/md5/md# echo repair > sync_action 
> >
> > md5 : active raid5 sdg1[0] sdd1[5] sde1[3] sdf1[2] sdh1[6]
> >       15627542528 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
> >       [==========>..........]  resync = 50.0% (1953925916/3906885632) finish=1899.1min speed=17138K/sec
> >       bitmap: 0/30 pages [0KB], 65536KB chunk
> 
> Yep, that is weird.
> 
> You can cause that to happen by e.g
>    echo 7813771264 > /sys/block/md5/md/sync_min
> 
> but you are unlikely to have done that deliberately.
 
I might have done this by mistake instead of sync_speed_min, but as you
say, unlikely. Then again, this is not the main problem and I think you
did find the reason below.

> s_maxbytes will be MAX_LFS_FILESIZE which, on a 32bit system, is
> 
> #define MAX_LFS_FILESIZE        (((loff_t)PAGE_SIZE << (BITS_PER_LONG-1))-1)
> 
> That is 2^(12+31) or 2^43 or 8TB.
> 
> Is this a 32bit system you are using?  Such systems can only support
> buffered IO up to 8TB.  If you use iflags=direct to avoid buffering, you
> should get access to the whole device.

You found the problem, and you also found the reason why btrfs_tools
also fails past 8GB. It is indeed a 32bit distro. If I put a 64bit
kernel with the 32bit userland, there is a weird problem with a sound
driver/video driver sync, so I've stuck with 32bits.

This also explains why my btrfs filesystem mounts perfectly because the
kernel knows how to deal with it, but as soon as I use btrfs check
(32bits), it fails to access data past the 8TB limit, and falls on its
face too.
myth:/sys/block/md5/md# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8190
dd: reading `/dev/md5': Invalid argument
2+0 records in
2+0 records out
2147483648 bytes (2.1 GB) copied, 37.0785 s, 57.9 MB/s
myth:/sys/block/md5/md# dd if=/dev/md5 of=/dev/null bs=1GiB skip=8190 count=3 iflag=direct
3+0 records in
3+0 records out
3221225472 bytes (3.2 GB) copied, 41.0663 s, 78.4 MB/s

So a big thanks for solving this mystery.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
