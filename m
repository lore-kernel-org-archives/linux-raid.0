From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 00:28:00 -0500
Message-ID: <5796F4E0.9070206@suddenlinkmail.com>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/25/2016 11:18 PM, Adam Goryachev wrote:
> It sounds/looks like you partitioned the two drives with GPT, and then used the
> entire drive for the RAID, which probably overwrote at least one of the GPT
> entries. Now gparted has overwritten part of the disk where mdadm keeps it's data.
> 
> So, good news, assuming you really haven't touched sdc, then it should still be
> fine. Try the following:
> mdadm --manage --stop /dev/md4
> 
> Check it has stopped cat /proc/mdstat and md4 should not appear at all.
> 
> Now re-assemble with only the one working member:
> mdadm --assemble --force /dev/md4 /dev/sdc
> 
> If you are lucky, you will then be able to mount /dev/md4 as needed.
> 
> If not, please provide:
> Output of the above mdadm --assemble
> Logs from syslog/dmesg in relation to the assembly attempt
> mdadm --query /dev/sdc
> mdadm --query /dev/sdc1
> mdadm --query /dev/sdd
> mdadm --query /dev/sdd1
> mdadm --detail /dev/md4 (after the assemble above).
> 
> Being RAID1, it shouldn't be too hard to recover your data, just need to get
> some more information about the current state.
> 
> Once you have the array started, your next step is to avoid the problem in
> future. So send through the above details, and then additional advice can be
> provided. Generally I've seen most people create the partition and then use the
> partition for RAID, that way the partition is marked as in-use by the array. The
> alternative is to wipe the beginning and end of the drive (/dev/zero) and then
> re-add to the array. Once synced, you can repeat with the other drive. The
> problem is if something (eg your BIOS) decides to "initialise" the drive for
> you, then it will overwrite your data/mdadm data.
> 
> Hope the above helps.
> 
> Regards,
> Adam

Adam,

  Thank you! There are a lot of things in life I'm good at, speaking mdadm
fluently, when I deal with it once every 2 years -- isn't one of them.

  /dev/sdc was still OK and did assemble in degraded mode just fine:

# mdadm --manage --stop /dev/md4
mdadm: stopped /dev/md4

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdb6[1] sda6[0]
      52396032 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sdb5[1] sda5[0]
      511680 blocks super 1.2 [2/2] [UU]

md3 : active raid1 sdb8[1] sda8[0]
      2115584 blocks super 1.2 [2/2] [UU]

md2 : active raid1 sdb7[1] sda7[0]
      921030656 blocks super 1.2 [2/2] [UU]
      bitmap: 0/7 pages [0KB], 65536KB chunk

# mdadm --assemble --force /dev/md4 /dev/sdc
mdadm: /dev/md4 has been started with 1 drive (out of 2).

# cat /proc/mdstat
Personalities : [raid1]
md4 : active raid1 sdc[0]
      2930135488 blocks super 1.2 [2/1] [U_]
      bitmap: 0/22 pages [0KB], 65536KB chunk

Up and running, mounted with all data in tact (well, at least until I hit the
address in the partition table where the mdadm data overwrote part of the
partition table -- I see a Segmentation Fault coming)

So I take it having one large raid1 filesystem created out of a primary
partition on a disk is a bad idea? My goal in doing so was to create the largest
block of storage out of the two drives I could (saving 100M unpartitioned at the
end in case of drive failure and disk size variance)

How should I proceed if I want to create a large raid1 array out of the two
disks? Should I create a logical/extended partition setup and then create the
array out of the extended partition? (that is the setup I have for all other
raid1 disks that also hold /boot, /, /home, etc....

I take it adding sdd back into md4 is not a good idea at this point.

Do I implement a new partition scheme on sdd, and then "create" a new single
disk raid1 array (say md5), mount it on some temporary mount point, copy the
data, then stop both, assemble what was sdd/md5 as md4 then nuke the partitions
on sdc, repartition sdc (as I did sdd) and then add sdc to the new array with
sdd? (or I could dump the data to some temp location, nuke both sdc and sdd,
repartition, recreate, assemble and then copy back to the new fully functional
array -- that sounds better)

What are your thoughts on the partition scheme and the approach outlined above?
And thank you again for steering me straight and saving the data.



-- 
David C. Rankin, J.D.,P.E.
