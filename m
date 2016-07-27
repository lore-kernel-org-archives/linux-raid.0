From: Phil Turmel <philip@turmel.org>
Subject: Re: SOLVED [was Re: GPT corruption on Primary Header, backup OK,
 fixing primary nuked array -- help?]
Date: Wed, 27 Jul 2016 10:22:09 -0400
Message-ID: <f0ebae2f-472f-6835-d74b-f3fccd4c6b04@turmel.org>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
 <5797C415.8010206@suddenlinkmail.com>
 <CAJCQCtSkE+-C5U9OEm0-zazLW2KHCMUqduDTA=UHsMxmf4DVrQ@mail.gmail.com>
 <5797E869.8080403@suddenlinkmail.com>
 <CAJCQCtQpGVf2Tj13o57T4=raF=czYr-V99tEDSkJ-_buk7JtTg@mail.gmail.com>
 <57985F10.4070706@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57985F10.4070706@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi David,

On 07/27/2016 03:13 AM, David C. Rankin wrote:

> Chris, Phil, All,
> 
>   Thank you. For anyone else that is faced with the problem where you are using
> whole disks in your raid1 array over the top of unused sub-partitions, here is
> the 5 minute fix.

Glad you got it sorted out.

> How I solved the problem:
> 
>   (1) do NOT attempt to alter the disk in a partitioning package like fdisk,
> sfdisk, gdisk, parted, etc.. A write after you delete the unused partitions with
> adversely affect the md data and will require a long and painful resync
> depending on the size of your drive.

Correct.

>   (2) simply --fail and --remove one drive from the array. My array was
> /dev/md4, and failing and removing /dev/sdd from the array was as simple as:
> 
> # mdadm /dev/md4 --fail /dev/sdd
> # mdadm /dev/md4 --remove /dev/sdd

Unnecessary, and you have no redundancy for the duration.  Using dd to
wipe the first 4k of a v1.2 array member is entirely safe to do while
running.

>   (3) To remove the inadvertent partition on the drive while keeping the raid
> data in tact, you must remove the PMBR and primary Partition tables from the
> drive. You can use `wipefs` or simply use `dd` to overwite the first 4096 bytes
> on the drive with zeros and then the last 1024 bytes before the end of the disk
> to remove the backup GPT header. (I overwote the last 4096 bytes on the disk,
> just to make sure -- I had nothing in the last 100M of the disk, so that seemed
> fine) You can look at the disk geometry reported by gdisk to find the end of the
> disk (the number of logical sectors -- make sure the disk has 512-byte sectors,
> or dd option adjustments will be needed) (then just subtract 8 from that number
> (or 2 if you wish to limit the write to 1024 bytes) and use that as the 'seek'
> offset with 'dd', so
> 
>   # dd of=/dev/sdd if=/dev/zero bs=4096 count=1
>   # dd of=/dev/sdd if=/dev/zero bs=512 count=8 seek=5860533160

I always place of=/dev/.... last on a dd command line just in case.

Using dd to write near the end of a member device is entirely safe while
running if the location is after the "Used Data Area"+"Data Offset" of
the device, as reported by mdadm --examine.

If you are zeroing a backup GPT that has corrupted part of your data
inside the data area, it doesn't do any additional harm.  So don't
bother using --fail and --remove on the member devices.

Phil
