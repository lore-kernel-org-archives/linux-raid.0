From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid 6 recovery
Date: Tue, 31 Oct 2017 16:27:42 +0000
Message-ID: <59F8A47E.2000405@youngman.org.uk>
References: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cf135ab9-1111-65cd-1074-5259a7eb133d@safeandsoundit.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Crisp <jcrisp@safeandsoundit.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/10/17 15:42, John Crisp wrote:
> Hi,
> 
> Returning once again to this list for some help and advice.

Doing a first-responder job ... :-)
> 
> Long story short I have a failed Raid 6 array that I would like to try
> and recover. The data is not vitally important as I have most of it in a
> number of other places, but I'd like to try and resurrect the array if
> possible, as much to learn as anything.
> 
Looks very promising ...

> The array had an issue some while ago, but as I had no space to store
> any recovered data I left the machine off.
> 
> The OS is Xubuntu 14.04
> 
> The system consisted of a boot/OS array with two mirrored drives (which
> is fine), and then a Raid 6 data array which consisted of 8 300Gb Ultra
> Wide SCSI drives. 7 were in the array with a spare (if my memory serves
> me correctly).

Okay. That makes 5 data drives, 2 parity, one spare. I'm wondering if
one drive failed a while back and was rebuilt, so you didn't have the
spare you think you did. I'm half-hoping that's the case, because if it
fell over in the middle of a rebuild, that could be a problem ...
> 
> As far as I remember the machine suffered a power failure. When it
> powered up again, the system tried to restore/rebuild the array. During
> this I think the power failed again (don't ask.....) It suffered at lest
> one disk failure. I then left it off to try another day.
> 
> Drive layout is as follows:
> 
> RAID 1 mirror /dev/sda + b
> 
> RAID 6 array /dev/sd[cdefghij]
> 
> /dev/sdd was dead and has been replaced.


> 
> As far as I remember I created the array, then added a partition and
> then LVM (possibly not a good idea in hindsight). So none of the
> individual drives show a partition......
> 
> I had a good read here and created some of the scripts.
> 
> https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID
> 
> Here is some of the output I have got so far. Any advice appreciated.
> 
> B. Rgds
> John
> 
> 
> 
> root@garage:~# sed -e '/^[[:space:]]*$/d' -e '/^[[:space:]]*#/d'
> /etc/mdadm/mdadm.conf
> CREATE owner=root group=disk mode=0660 auto=yes
> HOMEHOST <system>
> MAILADDR root
> DEVICE partitions
> ARRAY /dev/md0 metadata=1.2 name=garage:0
> UUID=90624393:3b638ad8:9aeb81ca:fa3caafc
> ARRAY /dev/md1 metadata=1.2 name=garage:1
> UUID=f624610a:b711ff4b:3b126550:a8f78732
> ARRAY /dev/md/Data metadata=1.2 name=garage:Data
> UUID=1a2f92b0:d7c1a540:165b9ab7:0baed449
> 
> 
> cat /proc/mdstat
> 
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md127 : inactive sdf[3](S) sdh[5](S)
>       585675356 blocks super 1.2
> 
> md1 : active raid1 sda5[2] sdb5[3]
>       292674368 blocks super 1.2 [2/2] [UU]
> 
> md0 : active raid1 sda1[2] sdb1[3]
>       248640 blocks super 1.2 [2/2] [UU]
> 
> unused devices: <none>
> 
> mdadm --stop /dev/md127
> 
> 
> Notice the following will not work with /dev/sdc1 as there is no
> partition on the drive. Have to use /dev/sdc :
> 
> UUID=$(mdadm -E /dev/sdc|perl -ne '/Array UUID : (\S+)/ and print $1')
> echo $UUID
> 1a2f92b0:d7c1a540:165b9ab7:0baed449
> 
> DEVICES=$(cat /proc/partitions | parallel --tagstring {5} --colsep ' +'
> mdadm -E /dev/{5} |grep $UUID | parallel --colsep '\t' echo /dev/{1})
> 
> echo $DEVICES
> /dev/sdc /dev/sde /dev/sdf /dev/sdh /dev/sdi
> 
> 
> Create overlays:
> 
> root@garage:~# ./overlayoptions.sh create
> Currently set device are
> /dev/sdc /dev/sde /dev/sdf /dev/sdh /dev/sdi
> Input is create
> Creating Overlay
> free 235071M
> Clear any old overlays
> Removing Overlay
> /dev/sdc 286102M /dev/loop0 /dev/mapper/sdc
> /dev/sde 286102M /dev/loop1 /dev/mapper/sde
> /dev/sdf 286102M /dev/loop2 /dev/mapper/sdf
> /dev/sdh 286102M /dev/loop3 /dev/mapper/sdh
> /dev/sdi 286102M /dev/loop4 /dev/mapper/sdi
> 
> 
> root@garage:~# mdadm --assemble --force /dev/md127 $OVERLAYS
> mdadm: clearing FAULTY flag for device 3 in /dev/md127 for /dev/mapper/sdh
> mdadm: Marking array /dev/md127 as 'clean'
> mdadm: failed to add /dev/mapper/sde to /dev/md127: Invalid argument
> mdadm: failed to add /dev/mapper/sdi to /dev/md127: Invalid argument
> mdadm: /dev/md127 assembled from 2 drives and  1 rebuilding - not enough
> to start the array.
> 
This worries me. We have 5 drives, which would normally be enough to
recreate the array - a quick "--force" and we're up and running. Except
one drive is rebuilding, so we have one drive's worth of data scattered
across two drives :-(

Examine tells us that sdd, sdg, and sdj have been partitioned. What does
"fdisk -l" tell us about those drives? Assuming they have one large
partition each, what does "--examine" tell us about sdd1, sdg1 and sdj1
(assuming that's what the partitions are)?
> 
> 
> root@garage:~# mdadm --examine /dev/sd[cdefghij] |grep Event
>          Events : 1911
>          Events : 1911
>          Events : 1910
>          Events : 1910
>          Events : 1911
> 
> (Two drives have older Events)
> 
Do you mean the two with 1910? That's no great shakes.
> 
> 
> 
> root@garage:~# mdadm --examine /dev/sd[cdefghij]
> /dev/sdc:

Snip the details ... :-)

First things first, I'd suggest going out and getting a 3TB drive. Once
we've worked out where the data is hiding on sdd, sdg, and sdj you can
ddrescue all that into partitions on this drive and still have space
left over. That way you've got your original drives untouched, you've
got a copy of everything on a fresh drive that's not going to die on you
(touch wood), and you've got spare space left over. (Even better, a 4TB
drive and then you can probably backup the array into the space left
over!). That'll set you back just over £100 for a Seagate Ironwolf or
similar.

Second, as I say, work out where that data is hiding - I strongly
suspect those drives have been partitioned.

And lastly, go back to the wiki. The page you read was the last in a
series - it would pay you to read the lot.

https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

Note especially the utility lsdrv, which will tell the experts here
straight away where your data has decided to play hide-and-seek.

ESPECIALLY if you've ddrescued the data to a new drive, I suspect it
will be a simple matter of "--assemble --force" and your array will back
up and running in a flash - well, maybe not a flash, it's got to rebuild
and sort itself out, but it'll be back and working.

(And then, of course, if you have built a new raid with a bunch of
partitions all on one disk, you need to backup the data, tear down the
raid, and re-organise the disk(s) into a more sensible long-term
configuration).

Oh - and putting LVM on top of a raid is perfectly sensible behaviour.
We have a problem with the raid - let's fix the raid and your LVM should
just come straight back.

Cheers,
Wol
