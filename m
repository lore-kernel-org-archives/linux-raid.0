From: Andrew Ryder <tireman@shaw.ca>
Subject: Re: Cry for help before I screw up a raid recovery more...
Date: Tue, 22 Apr 2014 04:54:59 -0400
Message-ID: <53562E63.70009@shaw.ca>
References: <53561841.3060907@csun.edu> <535621B9.90003@shaw.ca> <53562482.5010200@csun.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53562482.5010200@csun.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Wiegley <jeffw@csun.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't know enough to say about the size of the superblock, but I'm 
going to guess it doesn't. I'm guessing the superblock for XFS is 
probably damaged or not in the spot where it is now expected to be..

When I was trying to fix my problem, I came across about using 
'parallel' to test array fixes without hosing the actual system, might 
be worth checking out.

https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID


Andrew


On 04/22/14 04:12, Jeff Wiegley wrote:
> Correct. I think this is correct. But one outstanding question is:
> are superblocks different sizes for different levels? I accidentally
> recreated the array as level 5 when it was actually initially a
> level 6. I think this may have permanently overwritten part of the
> LUKS data and destroyed my chances of rebuilding the array correctly.
>
> I don't want to recreate on large array unless it's not going to
> permanently damage things as it seems to have done on the small one.
>
> Though... on a positive note: I did find backups of my luks headers.
> I did: cryptsetup --header nas.luks luksOpen /dev/md3 md3
> and it dutifully asks me for a passphrase AND accepts the passphase.
> however, mounting the XFS filesystem that use to be there... doesn't
> work. which I think is REALLY weird. the encryption keys are there
> and recognized which should indicate a pretty good level of data
> integrity but the filesystem under the encryption seems non-existant.
>
> Still hoping that somebody can confirm that recreating the large,
> important raid array but using the right level first will result in
> avoiding the corruption I [may] have created on the smaller,
> insignificant array.
>
> - Jeff
>
> On 4/22/2014 1:00 AM, Andrew Ryder wrote:
>>   From what I understand and my experience recently, as long as you don't
>> don't touch anything other than the superblock with mdadm, ie re-sync
>> the arrays, filesystem check/rebuild the data should be there intact as
>> long as you can re-create the superblock exactly as it was before.
>> Re-writing the superblock a few times over to get it right shouldn't
>> harm anything.
>>
>> You'll need the --examine output from mdadm for at least one drive in
>> the array's superblock you want to rebuild so you can spec the right
>> parameters to put things in order, letting mdadm guess what the array's
>> geometry is is a big crapshoot.
>>
>> I ended up with a command looking like:
>>
>> mdadm --create /dev/md2 --assume-clean --level=5 --chunk=<size>
>> --layout=<layout type> --size<used dev size> --data-offset=<value>
>> --raid-devices=4 /dev/sda1 /dev/sdb1 /dev/sde1 missing
>>
>> For the <used dev size> you need to pull that from the mdadm --examine
>> from the existing/original superblock if you have a copy of it lying
>> around.. Take the "Used Dev Size" divide by 2 and input it for --size.
>> What I know is when you try and create the array, mdadm will complain
>> about a size mismatch and give you a value and a value+metadata. From my
>> experience, you want the smaller value. (About -130kb)
>>
>> You'll also need to know the "chunk size" and "Data Offset" from the
>> superblock of the existing array. The "Unused Space" before and after
>> sectors must match up. When I was finished my before sectors was 1968
>> and after re-creating was 1960 and the after sectors was not even close.
>>
>> If you do get the array rebuilt and can mount it, backup the data before
>> you run any fscks to repair anything then once you have your stuff back,
>> re-create the array and re-format with a new fs so you know your good.
>>
>> Hope that helps..
>>
>> Andrew
>>
>>
>> On 04/22/14 03:20, Jeff Wiegley wrote:
>>> So I read this: "You have been warned! It's better to send an email to
>>> the linux-raid mailing list with detailed information..." and so here I
>>> am. Hopefully somebody can help provide me with a solution.
>>>
>>> I have a fileserver that has six 3TB disks in it:
>>> /dev/sd{a,b,c,d,e,f}
>>>
>>> plus /dev/sdg and /dev/sdh which I put the OS on but they aren't
>>> important/have no valuable data other than raw OS.
>>>
>>> partition tables are GPT format:
>>>     root@nas:~# parted -l
>>>     Model: ATA Hitachi HDS5C303 (scsi)
>>>     Disk /dev/sda: 3001GB
>>>     Sector size (logical/physical): 512B/512B
>>>     Partition Table: gpt
>>>
>>>     Number  Start   End     Size    File system  Name        Flags
>>>      1      1049kB  275GB   275GB                Linux RAID  raid
>>>      2      275GB   3001GB  2726GB               Linux RAID  raid
>>>
>>>
>>>     Model: ATA ST3000DM001-9YN1 (scsi)
>>>     Disk /dev/sdb: 3001GB
>>>     Sector size (logical/physical): 512B/4096B
>>>     Partition Table: gpt
>>>
>>>     Number  Start   End     Size    File system  Name        Flags
>>>      1      1049kB  275GB   275GB                Linux RAID  raid
>>>      2      275GB   3001GB  2726GB               Linux RAID  raid
>>>
>>>
>>>     Model: ATA Hitachi HDS5C303 (scsi)
>>>     Disk /dev/sdc: 3001GB
>>>     Sector size (logical/physical): 512B/512B
>>>     Partition Table: gpt
>>>
>>>     Number  Start   End     Size    File system  Name        Flags
>>>      1      1049kB  275GB   275GB                Linux RAID  raid
>>>      2      275GB   3001GB  2726GB               Linux RAID  raid
>>>
>>>
>>>     Model: ATA ST3000DM001-1CH1 (scsi)
>>>     Disk /dev/sdd: 3001GB
>>>     Sector size (logical/physical): 512B/4096B
>>>     Partition Table: gpt
>>>
>>>     Number  Start   End     Size    File system  Name        Flags
>>>      1      1049kB  275GB   275GB                Linux RAID  raid
>>>      2      275GB   3001GB  2726GB               Linux RAID  raid
>>>
>>>
>>> The server was supplying two linux RAID arrays:
>>> /dev/md3: consisting of /dev/sd{a,b,c,d,e,f}1 (a little over 1TB raided)
>>> /dev/md4: consisting of /dev/sd{a,b,c,d,e,f}2 (a little over 10TB raid)
>>>
>>> The /dev/sdf drive failed. I took it out. checked it with SeaTools and
>>> repaired it. But I upgraded software on the Ooperating system partitions
>>> while it was out and basically screwed the OS side of things and had to
>>> reinstall. The OS resides on entirely separate drives and I don't store
>>> anything of worth on those drives at all. So I figured I could reinstall
>>> the OS and leave the storage raid drives untouched and bring them up
>>> after.
>>>
>>> /proc/mdstat prior to reinstallation showed:
>>>     Personalities : [raid6] [raid5] [raid4] [raid1] [linear] [multipath]
>>> [raid0] [raid10]
>>>     md2 : active raid1 sdh4[1] sdg4[0]
>>>           241280888 blocks super 1.2 [2/2] [UU]
>>>
>>>     md0 : active raid1 sdh1[1] sdg1[0]
>>>           975860 blocks super 1.2 [2/2] [UU]
>>>
>>>     md1 : active raid1 sdh3[1] sdg3[0]
>>>           7811060 blocks super 1.2 [2/2] [UU]
>>>
>>>     md3 : active raid6 sda1[0] sdc1[2] sde1[4] sdb1[1] sdd1[6]
>>>           1073735680 blocks super 1.2 level 6, 512k chunk, algorithm 2
>>> [6/5] [UUUUU_]
>>>
>>>     md4 : active raid6 sdf2[7](F) sda2[0] sdc2[2] sde2[4] sdb2[1]
>>> sdd2[6]
>>>           10647314432 blocks super 1.2 level 6, 512k chunk, algorithm 2
>>> [6/5] [UUUUU_]
>>>
>>>     unused devices: <none>
>>>
>>> ####
>>> HERE'S were I went stupid wrong: during the Ubuntu installation I
>>> noticed that the installation/kernel automatically assembled all of
>>> my md devices. I wanted to make sure it never touched the md3 and md4
>>> raids so I had the installer delete them. Well, it turns out it doesn't
>>> just stop them. It literally destroys them and wipes their superblocks.
>>>
>>> So now after the machine is back up....
>>> root@nas:~# mdadm --examine /dev/sda2
>>> mdadm: No md superblock detected on /dev/sda2.
>>>
>>> none of the storage drive partitions have superblocks anymore.
>>>
>>> I looked for backups of the superblocks and I can't find any.
>>>
>>> The good news is that /dev/md3 (the smaller raid) is something I don't
>>> really care about so I'm comfortable losing all its data. So I figured
>>> I would try to create a new superblock.
>>>
>>> so I have already done...
>>> mdadm --create /dev/md3 --assume-clean --level=5 --verbose
>>> --raid-devices=6 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>>> missing
>>>
>>> and of course now mdstat shows an md3 device ready.
>>>
>>> I had an encrypted luks system on there. so I then did
>>> root@nas:~# cryptsetup luksOpen /dev/md3 md3
>>> Device /dev/md3 is not a valid LUKS device.
>>>
>>> and of course that's when I started to resolve myself that everything
>>> was lost.
>>>
>>> But... looking at the capture of mdstat prior to my stupidity I see I
>>> made a grave mistake...
>>> md3 : active raid6 sda1[0] sdc1[2] sde1[4] sdb1[1] sdd1[6]
>>>         1073735680 blocks super 1.2 level 6, 512k chunk, algorithm 2
>>> [6/5] [UUUUU_]
>>>
>>> md3 USE to be a raid6, not a raid5.
>>>
>>> so I recreated the raid....
>>> mdadm --create /dev/md3 --assume-clean --level=6 --verbose
>>> --raid-devices=6 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>>> missing
>>>
>>> but still...
>>> root@nas:~# cryptsetup luksOpen /dev/md3 md3
>>> Device /dev/md3 is not a valid LUKS device.
>>>
>>> MY FIRST QUESTION: when using create to recovery raid arrays, do you
>>> destroy all hope by trying to create the wrong layout first? I.e. if
>>> I had used --level=6 the very first time would I have saved my array
>>> and my data but now that I was an idiot and did raid5 first I'm screwed
>>> on that device?
>>>
>>> SECOND QUESTION:  Should I go ahead and do
>>> mdadm --create /dev/md4 --assume-clean --level=6 --verbose
>>> --raid-devices=6 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2 /dev/sde2
>>> missing
>>>
>>> on my large, important dead raid? will this avoid the screw up on
>>> the small raid (possibly) caused by creating the wrong structure
>>> first?
>>>
>>> While that seems hopeful I have my doubts because of the following:
>>> In the original mdstat md3 was listed as:
>>> md3 : active raid6 sda1[0] sdc1[2] sde1[4] sdb1[1] sdd1[6]
>>>         1073735680 blocks super 1.2 level 6, 512k chunk, algorithm 2
>>> [6/5] [UUUUU_]
>>> and now I have that I have recreated with the proper structure it reads:
>>> md3 : active raid6 sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
>>>         1073215488 blocks super 1.2 level 6, 512k chunk, algorithm 2
>>> [6/5] [UUUUU_]
>>>
>>> which looks super from the point of having the same chuck size, same
>>> level, same superblock version and same algorithm. HOWEVER... the block
>>> sizes are now different which indicates something is not the same.
>>>
>>> So, while I am hopeful that re-creating md4 with the initial proper
>>> level I am fearful that this will still produce a different block size
>>> and I will be screwed.
>>>
>>> Yes, I know... I should have physically pulled the drives during the
>>> install. And I know now I should have backed up the superblocks. When
>>> I created the original devices I know I did. I just can't remember
>>> where I stored them; I'm still looking for them but at this point not
>>> real hopeful.
>>>
>>> I'm not going to recreate anything or run any more mdadm commands. I'll
>>> just patiently wait to see if you can give me some sound advice on
>>> how to proceed with least likelihood of [more] errors.
>>>
>>> Thank you,
>>>
>>> Jeff
>>>
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
