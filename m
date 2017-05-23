From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on
 md_attr_store / raid5_make_request
Date: Tue, 23 May 2017 15:47:49 +0100
Message-ID: <59244B95.4080600@youngman.org.uk>
References: <87lgppz221.fsf@esperi.org.uk>
 <87a865jf9a.fsf@notabene.neil.brown.name> <87o9ukykmk.fsf@esperi.org.uk>
 <592336E6.8080906@youngman.org.uk> <87y3toic67.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3toic67.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/17 02:39, NeilBrown wrote:
> On Mon, May 22 2017, Wols Lists wrote:
> 
>> On 22/05/17 16:30, Nix wrote:
>>> I'll give it a try -- I hit it twice in succession, once with a
>>> --backup-file, once without. Since mdadm does not warn about the lack of
>>> a --backup-file, I guess the statement in the manual that it is
>>> essential to provide one when changing RAID levels is untrue: I suspect
>>> that it's necessary *if* you're not increasing the number of disks at
>>> the same time, but since I'm growing into a spare, adding a
>>> --backup-file only slows it down?
>>
>> I did discuss this with Neil while I wrote it, so I hope I got it right :-)
>>
>> https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm#Array_internals_and_how_it_affects_mdadm
>>
>> aiui, provided you're using a v1 superblock, the data offset means there
>> is spare space on the drives precisely for the purpose (one of then at
>> least) of keeping a backup. So the reshape will start reshaping into the
>> spare space and eliminate the need for the backup - the new version of
>> the stripe will be safely written before the space occupied by the old
>> stripe is required.
>>
>> Cheers,
>> Wol
> 
> Proof-reading time.  I'll be very picky.  You'll ignore places where you
> think my pickiness isn't helpful.
> 
>> The first arrays did not have a superblock, and were declared in
>> mdadm.conf.
> 
> The first arrays (linear and raid0 only) did not have a superblock and
> were declared in "raidtab" which was managed by the deprecated
> "raid-tools" which have been replaced by mdadm.
> 
> mdadm does now allow you to declare no-superblock arrays in mdadm.
> You can build them with "mdadm --build .....", but that is all.
> 
>> and the backup area when reshaping an array.
> 
> Not quite.  The whole point of being able to move the data offset
> is that backup isn't needed.  Maybe it could read:
> 
>  ... and some extra space so that the data areas can be moved forward or
>  backward on the device by several stripes.  This is useful when
>  reshaping.
> 
>> All operations that involve moving data around are called reshapes,
>> and require some form of backup.
> 
>  All operations that involve moving data around are called reshapes and
>  need to be careful only to write to a region of the device which
>  can safely be corrupted.  If a system crash happens during a reshape,
>  the region that was being written to must be considered to contain
>  garbage.
>  The preferred mechanism is to relocate the data by a few stripes,
>  reading data from a region of the disk that contains live data, and
>  writing it into a sliding window that is otherwise unused.  After a few
>  stripes have been copied, the metadata in the superblock is updated, so
>  that the newly written data is now "live" and the location it was
>  copied from is now "unused" and can have more stripes copied into it.
>  This process results in the Data Offset being moved by several
>  megabytes, either forward or backward, and it is to allow for this to
>  happen that the Data Offset is set to several to many megabytes when an
>  array is created.
> 
>  If it is not possible to move the Data Offset, either because there is
>  no room or because the v0.90 superblock is in use, mdadm will take a
>  backup of the region of data being reshaped before it allows the
>  reshape to progress.  In the event of a crash, mdadm will restore this
>  data over the potentially corrupted region of the array before starting
>  the array.
> 
> Your current text already covers some of this, and there probably isn't a
> need to replace it all.
> But I think it is important not to talk about the reserved space in the
> devices a backup space.
> 
Thanks. I've updated the section. I've taken pretty much everything
you've said, but rewritten it in my own words, so that the page remains
consistent in style. I hope I haven't missed anything.

It's thrown up two little points I've noted on the page - if a v1.0
mirror has its offset changed, does this break the linux boot? (that's
the "without an initramfs" boot that doesn't assemble the mirror until
after the kernel is running).

And if you shut down cleanly during a backup-file reshape, is this fact
noted or does mdadm just assume any shutdown is dirty and use the backup
file anyway?

Cheers,
Wol

