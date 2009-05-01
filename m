From: "NeilBrown" <neilb@suse.de>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Sat, 2 May 2009 07:36:45 +1000 (EST)
Message-ID: <fb9dbbffc38b437042076747a41ddf9b.squirrel@neil.brown.name>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
    <18922.50050.860008.242658@notabene.brown>
    <slrnguupf4.911.Mario.Holbe@darkside.dyn.samba-tng.org>
    <slrngve39c.8a2.Mario.Holbe@darkside.dyn.samba-tng.org>
    <18938.23135.726382.733302@notabene.brown>
    <20090501175524.GA8163@darkside.22.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090501175524.GA8163@darkside.22.kls.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 2, 2009 3:55 am, Mario 'BitKoenig' Holbe wrote:
> On Fri, May 01, 2009 at 12:11:43PM +1000, Neil Brown wrote:
>> There some other places
>> where are are overflowing on a shift.  One of those (in
>> bitmap_dirty_bits) can cause the problem you see.
>> This patch should fix it.  Please confirm.
>
> Together with the small syntax-fix attached this patch fixes the
> allocation of half of the available pages only. Now, all pages are
> allocated when I set all bits and they all get cleaned in-kernel as well
> as on-disk.

Good.  Thanks for the confirmation (and fix).

>
> However, can you confirm that the bitmap is really used in raid10
> resync? I removed half of the disks (a correctly removable subset, of
> course :)), copied 100G to the degraded array, got about 7k bit set in
> the bitmap, (re-)added the removed devices (mdadm correctly states
> re-add as well), but the resync looks *very* sequential.
> Moreover: I stopped and re-assembled the array with about 2k bit left
> set and the resync starts from the beginning, I can see no skip to the
> previous position in the resync process.
> I'll try to watch this and will trigger you again when I have more
> stable evidence, but perhaps you have some faster test-cases, I have to
> wait for at least 5 hours now :)

I just did some testing and it does seem to honour the bitmap during
recovery.  However there are some caveats.

1/ it processes the whole array from start to finish in chunk-sized blocks
  and simply doesn't generate IO where it isn't needed.  This is different
  to e.g. raid1 where it can skip over a whole bitmap-chunk at at time.
  So it does use more CPU
2/ With raid1, when it skips a whole bitmap chunk, that chunk is not
  included in the speed calculation.  With raid10, everything is included.
  So I found the resync was hitting the limit of 200M/sec and backing off.
  I increased the limited (Added a few more zeros) and it sped up.
3/ I found a bug.  If you have two devices missing and add just one,
  then after the recovery it might clear the bitmap even though
  there is another missing device.  When that device is re-added, it will
  be added with no recovery.  This is bad.  I'll post a patch shortly.

What speed are (were) you getting for resync.  If it was around 200M/sec,
then point 2 would explain it.  If it was closer to the device speed,
then there must be something else going wrong.

NeilBrown

