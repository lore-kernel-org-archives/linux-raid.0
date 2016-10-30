From: Peter Hoffmann <Hoffmann.P@gmx.net>
Subject: Re: Panicked and deleted superblock
Date: Sun, 30 Oct 2016 21:45:27 +0100
Message-ID: <7f1dd791-ed1c-5db6-555d-ed377995420e@gmx.net>
References: <0e68051d-1008-cf9b-1f8f-0a0736b1c58f@gmx.net>
 <20161030194326.GA6727@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161030194326.GA6727@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 30, 2016 at 08:43:00PM +100 Andreas Klauer wrote:
> On Sun, Oct 30, 2016 at 07:23:00PM +0100, Peter Hoffmann wrote:
>> I assume that both processes - re-sync  and grow - raced
>> through the array and did their job.
> 
> Oi oi oi, it's still one process per raid, no races. Isn't it? 
> I'm not a kernel developer so I don't really *know* what happens 
> in this case, but in my imagination it should go something like 
> - disk that is not fully synced, treat as unsynced/degraded, repopulate.
> 
> Either that or it's actually smart enough to remember it synced up to X 
> and just does the right thing(tm), whatever that is. But that sounds 
> like having to write out a lot of special cases instead of handling 
> the degraded case you must be able to cope with anyhow.
> 
> You have to re-write it and recalculate all parity anyway since the grow 
> changes everything.
> 
> As long as it didn't consider your half a disk to be fully synced, 
> your data should be completely fine. The only question is - where. ;)
All right, but even if the re-sync stopped as I started growing, like
you wrote, there shouldn't anything be lost as growing consumes more
than it writes, stripe wise speaking

| (D1) |  D2  |  D3  |      |  D1  |  D2  |  D3  | (D4) |
|------|------|------|      |------|------|------|------|
| (B1) |  B2  | P1,2 | ->   |  B1  |  B2  |  B3  |(P123)|
| (B4) | P3,4 |  B3  |      |  B5  |  B6  | P456 | (B4) |
| (P)  |  B5  |  B6  |      |  ?   | [B5] | [B6] |      |
Where () shows non existent but should-be-there blocks and
      [] existing but shouldn't be there blocks

>> And after running for a while - my NAS is very slow (partly because all
>> disks are LUKS'd), mdstat showed around 1GiB of Data processed - we had
>> a blackout.
> 
> Stop trying to scare me! I'm not scared. 
> You you you and your spine-chilling halloween horror story.
> 
> Slow because of LUKS? You don't have LUKS below your RAID layer, right?
> Right? (Right?)
Ehm, ehm, may I call my lawer ;-) Yes,

/dev/sda2 --luks--> /dev/mapper/HDD_0 \
/dev/sdb2 --luks--> /dev/mapper/HDD_1 --raid--> /dev/md127 -ext4-> /raid
/dev/sdc2 --luks--> /dev/mapper/HDD_2 /

>> the RAID superblock is now lost
> 
> Other people have proved Murphy's Law before, you know, 
> why bother doing it again?
> 
>> My idea is to look for that magic number of the ext4-fs to find the
>> beginning of Block 1 on Disk 1, then I would copy an reasonable amount
>> of data and try to figure out how big Block 1 and hence chunk-size is -
>> perhaps fsck.ext4 can help do that?
> 
> Determining the data offset, that's fine, only one thing to consider.
> Growing RAIDs changes that very offset you're looking for, so.
> Even if you find it, it's still wrong.
> 
>> One thing I'm wondering is if I got the layout right. And the other
>> might be rather a case for the ext4-mailing list but I'd ask it anyway:
>> how can I figure where the file system starts to be corrupted?
> 
> Let's not care about your filesystem for now. Also forget fsck.
> 
> It's dangerous to go alone. Take this.
> 
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
> 
> Create two overlays. Two. Okay?
> 
> Overlay #1: You create your not-fully-grown 4 disk raid.
> 
> You have to figure out the disk order, raid level, metadata version,
* disk order seems pretty obvious to me _UU and later UUU_
* raid level is 5
* 1) data offset on the grown system seems to be 100000
     (at least I find ext4s magic signature at 100000+400+38)
  2) no idea where it might be for the unsynced version
* chunk size I have no idea, I might have adjusted it from the default
value for better alignment with the file system
* layout should be the default left-symetric
  (all diagrams in the original mail are wrong as data blocks in a
stripe start after parity block not with first disk)
* anything else?


> data offset, chunk size, layout, and some things I don't remember. 
> If you got it right there should be a filesystem on the raid device. 
> Or a LUKS header. Or something that makes any sense whatsoever at 
> least for however far the reshape actually progressed.
> 
> Overlay #2: You create your not-fully-synced 3 disk raid.
>             Leaving the not-fully-synced disk as missing.
> 
> Basically this is the same thing as #1, except the data offset 
> might be different, there's obviously no 4th disk, and one of 
> the other three missing.
> 
> There probably WON'T be a filesystem on this one because it's 
> already grown over. So the beginning of this device is garbage, 
> it only starts making sense after the area that wasn't reshaped.
So I'm looking for a sequence of bytes that is duplicated on both
overlays. This way I find the border between both parts.

> If it was unencrypted... oh well. It wasn't. Was it?
> Now you've done it, I'm confused.
> 
> Then you find the point where data overlaps and create a linear mapping. 
> It overlaps because 4 disk more space than 3 so 1GB on 4 won't overwrite 
> 1GB on 3 so there is an overlapping zone.
> 
> And you're done. At least in terms of having access to the whole thing.
> 
> Easy peasy.
> 
> Regards
> Andreas Klauer
Thank you, that overlay file system is the way to go

> PS: Do you _really_ not have anything left. Logfiles? Anything?
>     Maybe you asked anything about your raid anywhere before 
>     and posted examine along with it, tucked away in some 
>     linux forum or chat you might have perused...
> 
>     Please check. Your story is really interesting but nothing 
>     beats hard facts such as actual output of your crap.
I'd be happy to have any such things but I never had any trouble before
