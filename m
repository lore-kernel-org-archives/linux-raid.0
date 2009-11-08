From: Beolach <beolach@gmail.com>
Subject: Re: Successful RAID 6 setup
Date: Sat, 7 Nov 2009 23:42:39 -0700
Message-ID: <aebf5d970911072242l3876282fm93dc938dd3df1990@mail.gmail.com>
References: <20091104184049356.ZIDJ2725@cdptpa-omta04.mail.rr.com>
	<4AF5BDF3.8020907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF5BDF3.8020907@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Nov 7, 2009 at 11:35, Doug Ledford <dledford@redhat.com> wrote:
> On 11/04/2009 01:40 PM, Leslie Rhorer wrote:
>>       I would recommend a larger chunk size.  I'm using 256K, and even
>> 512K or 1024K probably would not be excessive.
>
> OK, I've got some data that I'm not quite ready to send out yet, but it
> maps out the relationship between max_sectors_kb (largest request size a
> disk can process, which varies based upon scsi host adapter in question,
> but for SATA adapters is capped at and defaults to 512KB max per
> request) and chunk size for a raid0 array across 4 disks or 5 disks (I
> could run other array sizes too, and that's part of what I'm waiting on
> before sending the data out).  The point here being that a raid0 array
> will show up more of the md/lower layer block device interactions where
> as raid5/6 would muddy the waters with other stuff.  The results of the
> tests I ran were pretty conclusive that the sweet spot for chunk size is
> when chunk size is == max_sectors_kb, and since SATA is the predominant
> thing today and it defaults to 512K, that gives a 512K chunk as the
> sweet spot.  Given that the chunk size is generally about optimizing
> block device operations at the command/queue level, it should transfer
> directly to raid5/6 as well.
>

This only really applies for large sequential io loads, right?  I seem
to recall
smaller chunk sizes being more effective for smaller random io loads.

>>> Is ext4 the ideal file system for my purposes?
>>
>>       I'm using xfs.  YMMV.
>>

I'm also using XFS, and for now it's maybe safer than ext4 (In the 2.6.32-rc
series, there was recently an obscure bug that could cause ext4 filesystem
corruption - it's fixed now, but that type of thing scares me).  But ext[234]
have forward compatibility w/ btrfs (you can convert an ext4 to a btrfs), so
if you want to use btrfs when it stabalizes, maybe you should go w/ ext3 or
ext4 for now.  But that might take a long time.  XFS can perform better than
ext[234], but if you're really only going to be accessing this over an 1Gib/s
network, it won't matter.

>>> Should I be investigating into the file system stripe size and chunk
>>> size or let mkfs choose these for me? If I need to, please be kind to
>>> point me in a good direction as I am new to this lower level file system
>>> stuff.
>>
>>       I don/'t know specifically about ext4, but xfs did a fine job of
>> assigning stripe and chunk size.
>
> xfs pulls this out all on it's own, ext2/3/4 need to be told (and you
> need very recent ext utils to tell it both stripe and stride sizes).
>
>>> Can I change the properties of my file system in place (ext4 or other)
>>> so that I can tweak the stripe size when I add more drives and grow the
>>> array?
>>
>>       One can with xfs.  I expect ext4 may be the same.
>
> Actually, this needs clarified somewhat.  You can tweak xfs in terms of
> the sunit and swidth settings.  This will effect new allocations *only*!
>  All of your existing data will still be wherever it was and if that
> happens to be not so well laid out for the new array, too bad.  For the
> ext filesystems, they use this information at filesystem creation time
> to lay out their block groups, inode tables, etc. in such a fashion that
> they are aligned to individual chunks and also so that they are *not*
> exactly stripe width apart from each other (which forces the metadata to
> reside on different disks and avoids the possible pathological case
> where you could accidentally end up with the metadata blocks always
> falling on the same disk in the array making that one disk a huge
> bottleneck to the rest of the array).  Once an ext filesystem is
> created, I don't think it uses the data much any longer, but I could be
> wrong.  However, I know that it won't be rearranged for your new layout,
> so you get what you get after you grow the fs.
>

You can change both the stride & stripe width extended options on an
existing ext[234] filesystem w/ tune2fs (w/ XFS, it's done w/ mount options),
and as I understand the tune2fs man page the block allocator should use
the new values, although it seems stripe width is maybe used more.


--
Conway S. Smith
