From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID tuning?
Date: Tue, 13 Jun 2006 06:21:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0606130620410.8834@p34.internal.lan>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com>
 <17550.2944.728044.154492@cse.unsw.edu.au> <448E127F.5010708@comcast.net>
 <Pine.LNX.4.56.0606130906370.27931@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0606130906370.27931@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Adam Talbot <talbotx@comcast.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

    mkfs -t xfs -f -d su=128k,sw=14 /dev/md9

Gordon, What speed do you get on your RAID, read and write?

When I made my XFS/RAID-5, I accepted the defaults for the XFS filesystem 
but used a 512kb stripe.  I get 80-90MB/s reads and ~39MB/s writes.

On 5 x 400GB ATA/100 Seagates (on a regular PCI bus, max, 133mb/s)

On Tue, 13 Jun 2006, Gordon Henderson wrote:

> On Mon, 12 Jun 2006, Adam Talbot wrote:
>
>> RAID tuning?
>> Just got my new array setup running RAID 6 on 6 disks.  Now I am looking
>> to tune it.  I am still testing and playing with it, so I dont mind
>> rebuild the array a few times.
>>
>> Is chunk size per disk or is it total stripe?
>
> As I understand it, (raid0,5&6,?) the chunk size is the amount of data the
> system will write to one disk before moving to the next disk. It probably
> affects all sorts of underlying "stuff" like buffers at the block level
> and so on. I guess the theory is that if you can fill up a chunk on N
> disks, and the kernel+hardware is capable of writing them in parallel (or
> as near as it can) then the overall write speed increases.
>
> I also think that the oder you give the drives to mdadm makes a difference
> - if they are on differnet controllers, and I asked this question
> recently, but didn't get any answers to it... An array I created this way
> recently, 2 SCSI chains, 7 drives on each, created using sda, sdh, sdb,
> sdi, etc. seems to come out as sda, sdb, sdc in /proc/mdstat, so who
> knows!
>
>> Will using mkfs.ext3 -b N make a performance difference?
>
> I've found that it does - if you get the right numbers, and not so much
> the -b option, (thats probabably optimal for most systems) but the -R
> stride=N option, as then ext3 can "know" about the chunk size and
> hopefully optimise its writes against that.
>
> A lot also depends on your usage paterns. If you're doing a lot of stuff
> with small files, or small writes, then a smaller (or the default) chunk
> size might be just fine - for streaming larger files, then a larger chunk
> size (& more memory ;-) might help - since you've got time to play here, I
> suggest you do :)
>
> One thing I did fine some time back though (and I never tracked it down,
> as I didn't have the time, alas)  was some data corruption when using
> anything other than the default strip size (or more correctly, the default
> -R stride= option in mkfs.ext3 - I think it might have been ext3 rather
> than the md stuff - this was an older server with older ext2 tools and a
> 2.6 kernel) I put together a quick & dirty little script to test this
> though - see
>
>  http://lion.drogon.net/diskCheck1
>
> I usually run this a few times on a new array, and will leave it running
> for as long as possible on all partitions if I can. Under ext3, I'll fill
> the disk with ramdom files, unmount it, force an fsck on it, then
> mount/delete all files/umount it, then do the fsck again. That script It
> basically creates a random file, then copies this all over the disk,
> copying the copy each time.
>
> As for more tuning, & ext3, there is a section in the (rather old now!)
> HowTo about the numbers.
>
>  http://www.tldp.org/HOWTO/Software-RAID-HOWTO-5.html#ss5.11
>
>> Are there any other things that I should keep in mind?
>
> Test it, thrash it, power-kill it, remove a drive randomly, fsck it,
> rebuild it, etc. before it goes live. Be as intimately familiar with the
> "administration"  side of things as you can, so thant if something does go
> wrong, you can calmly analyse whats wrong, remove a drive (if neccessary)
> and install & resync/build a new one if required.
>
> I've found it does help to do an fsck on it with it's reasonably full of
> files - if nothing else, it'll give you an indication of how long it will
> take should you ever have to do it for real. If your dealing with
> clients/managers/users, etc. it's always good to give them an idea, then
> you can go off and have a relaxing coffee or 2 ;-)
>
> And FWIW: I've been using RAID-6 on production servers for some time now
> and have been quite happy. It did save the day once when someone performed
> a memory upgrade on one server and somehow managed to boot the server with
> 2 drives missing )-: A reboot after a cable-check and a resync later and
> all was fine. (Is it just me, or are SATA cables and connectors rubbish?)
>
> Heres one I built earlier: (SCSI drives)
>
> md9 : active raid6 sdn1[13] sdm1[11] sdl1[9] sdk1[7] sdj1[5] sdi1[3]
> 	sdh1[1] sdg1[12] sdf1[10] sde1[8] sdd1[6] sdc1[4] sdb1[2] sda1[0]
> 	3515533824 blocks level 6, 128k chunk, algorithm 2 [14/14]
> 	[UUUUUUUUUUUUUU]
>
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md9              3.3T  239G  3.1T   8% /mounts/pdrive
>
> It's actually running XFS rather than ext3 - I did manage to have some
> testing with this, and the only thing that swayed me towards XFS for this
> box, was it's ability to delete files much much quicker than ext3 (and
> this box might well require large quantities of files/directories) to be
> deleted on a semi-regular basis. I used:
>
>   mkfs -t xfs -f -d su=128k,sw=14 /dev/md9
>
> to create it - I *think* those parameters are OK for a 128K chunk size
> array - it was hard to pin this down, but performance seems adequate.
> (it's a write by one process, once or twice a day, read by many sort of
> data store)
>
> I use stock Debian 3.1 & the mdadm that comes with it, but a custom
> compiled 2.6.16.x kernel.
>
> Good luck!
>
> Gordon
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
