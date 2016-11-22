From: Felipe Kich <fkich1977@gmail.com>
Subject: Re: Help in recovering a RAID5 volume
Date: Tue, 22 Nov 2016 14:12:10 -0200
Message-ID: <CA+GmhESq=9MtnU8baeHUd+8eCwFDDycLXmihdgxU3WHFsFCNfw@mail.gmail.com>
References: <CA+GmhESH-2hDJrOjvNzVBsgCP65BnUE2AbfOZ1Bbrp02jyBNUQ@mail.gmail.com>
 <5824A918.3030300@youngman.org.uk> <CA+GmhESqEQd6J3CSteR08qw907NnC7r1ewecs3NkWUmpei6BVw@mail.gmail.com>
 <5824C354.3060209@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5824C354.3060209@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again Anthony,

Well, it's been two weeks and only now I got the time to return to the
task of trying to recover that failed RAID5 volume.
Following your recommendations I ddrescue'd all 4 1TB drives to a
single (partitioned) 4TB drive.
Problem is, now mdadm can't mount the array, it's compaining about
missing superblocks. Below is what I've done so far.

I've created four partitions on a single 4TB HDD. I then used ddrescue
to copy the contents from the original disks to it.
To avoid confusion when reading the logs, let me explain how the
computer was setup:

- sda is the system disk. Runs Mint.
- sdb is the 4TB disk.
- sdc is a 1TB disk from the array. I connected the 1st disk,
ddrescue'd it, shut down the PC, replaced the disk, and so on. So, the
original disks are always sdc in the outputs below.

So disk1 (sda) was copied to sdb1, disk2 (sdb) to sdb2, disk3 (sdc) to
sdb3 and disk4 (sdd) to sdb4.

I've used ddrescue version 1.19 and always the same command line:
ddrescue --force --verbose /dev/sdc2 /dev/sdb% mapfile.disco%

--------------------------------------------------------------------------------
Mapfile for Disk 1

# current_pos  current_status
0xE864540000     +
#      pos        size  status
0x00000000  0xE864546400  +
--------------------------------------------------------------------------------
Mapfile for Disk 2

# current_pos  current_status
0xE864540000     +
#      pos        size  status
0x00000000  0xE864546400  +
--------------------------------------------------------------------------------
Mapfile for Disk 3

# current_pos  current_status
0x3FDB717C00     +
#      pos        size  status
0x00000000  0x3FDB717000  +
0x3FDB717000  0x00001000  -
0x3FDB718000  0xA888E2E400  +
--------------------------------------------------------------------------------
Mapfile for Disk 4

# current_pos  current_status
0xE864546000     +
#      pos        size  status
0x00000000  0x3A78C80000  +
0x3A78C80000  0xADEB8B0000  -
0xE864530000  0x00001000  +
0xE864531000  0x00013000  -
0xE864544000  0x00001000  +
0xE864545000  0x00001400  -
--------------------------------------------------------------------------------

After that, I tried to verify the data in the partitions, and got that:

--------------------------------------------------------------------------------
root@it:/home/it/Desktop# mdadm --examine /dev/sdb
/dev/sdb:
   MBR Magic : aa55
Partition[0] :  4294967295 sectors at            1 (type ee)

root@it:/home/it/Desktop# mdadm --examine /dev/sdb1
mdadm: /dev/sdb1 has no superblock - assembly aborted

root@it:/home/it/Desktop# mdadm --examine /dev/sdb2
mdadm: /dev/sdb2 has no superblock - assembly aborted

root@it:/home/it/Desktop# mdadm --examine /dev/sdb3
mdadm: /dev/sdb3 has no superblock - assembly aborted

root@it:/home/it/Desktop# mdadm --examine /dev/sdb4
mdadm: /dev/sdb4 has no superblock - assembly aborted
--------------------------------------------------------------------------------

And if I try to assemble the array, mdadm tells me that there's no
superblocks in sdb1.

So now I'm stuck. Any tips on what should I do next?

I don't know if it matters, but the original disks have 2 partitions,
the first being where the EMC Lifeline software is installed (less
than 2GB), and the rest is the data partition. When I ddrescue'd, I
only copied the 2nd (data) partition.

Out of curiosity, I opened GParted to see if it can identify the
partitions. It recognizes sdb1 and sdb4 as "LVM PV", but sdb2 and sdb3
are unknown.

That's it for now. I'll keep reading about what can be done and
waiting for some more help from the list.

Regards,

-
Felipe Kich
51-9622-2067


2016-11-10 16:58 GMT-02:00 Wols Lists <antlists@youngman.org.uk>:
> On 10/11/16 17:47, Felipe Kich wrote:
>> Hi Anthony,
>>
>> Thanks for the reply. Here's some answers to your questions and also
>> another question.
>>
>> It really seems that 2 disks are bad, but 2 are still good, according
>> to SMART. I'll replace them ASAP.
>> For now, I don't need to increase the array size. It's more than
>> enough for what I need.
>>
> You might find the extra price of larger drives is minimal. It's down to
> you. And even 2TB drives would give you the space to go raid-6.
>
>> About the drive duplication, I don't have spare discs available now
>> for that, I only have one 4TB disk at hand, so I'd like to know if
>> it's possible to create device images that I can mount and try to
>> rebuild the array, to test if it would work, then I can go and buy new
>> disks to replace the defective ones.
>
> Okay, if you've got a 4TB drive ...
>
> I can't remember what the second bad drive was ... iirc the one that was
> truly dud was sdc ...
>
> So. What I'd do is create two partitions on the 4TB that are the same
> (or possibly slightly larger) than your sdx1 partition. ddrescue the 1
> partition from the best of the dud drives across. Create two partitions
> the same size (or larger) than your sdx2 partition, and likewise
> ddrescue the 2 partition.
>
> Do a --force assembly, and then mount the arrays read-only. The
> partition should be fine. Look over it and see. I think you can do a
> fsck without it actually changing anything. fsck will probably find a
> few problems.
>
> If everything's fine, add in the other two partitions and let it rebuild.
>
> And then replace the drives as quickly as possible. With this setup
> you're critically vulnerable to the 4TB failing. Read up on the
> --replace option to replace the drives with minimal risk.
>>
>> And sure, I'll send you the logs you asked, no problem.
>>
>> Regards.
>>
> Ta muchly.
>
> Cheers,
> Wol
