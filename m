From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: RAID header in XFS area?
Date: Sat, 4 Nov 2017 22:55:03 +0000
Message-ID: <5cffac57-7e37-b8cb-ee77-cb9cb6c0f616@youngman.org.uk>
References: <CAGRSmLv2HqyZmf-nR4SqnPaw2HNxDAaOSMA-QXVyiekF4Q5x5w@mail.gmail.com>
 <59FE0739.8020400@youngman.org.uk>
 <CAGRSmLuoauKaSZ5Z73+Tg19e_1q9Tc-A0ZjqMgr4Lv9Tfer6QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLuoauKaSZ5Z73+Tg19e_1q9Tc-A0ZjqMgr4Lv9Tfer6QQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/17 21:53, David F. wrote:
> thanks, but what about the RAID header being in the file system area?
> What happened to the actual sector data that belongs there (is there a
> way to find it from the raid header?) when not a md device?
> 
Sorry but I don't think You've quite grasped what a device is.

Let's start with sdb, the drive you're concerned about. The first 1MB is 
reserved space, the very first 512B is special because it contains the 
MBR, which defines the sub-devices sdb1, sdb2, sdb3 and sdb4.

Then mdadm comes along, and is given sdb1 and sd?1. It reserves the 
first few megs of the devices it's given (just like fdisk reserves the 
first meg), writes the superblock at position 4K (just like fdisk writes 
the MBR at position 0), and then just like the MBR defines sdb1 as 
starting at sector 2049 of sdb, so the superblock defines md0 as 
starting at a certain offset into sdb1. So that superblock will tell you 
where on the disk your filesystem actually starts.

WARNING - unless your superblock is 1.0 (and maybe even then) the start 
of your filesystem will move around if you add or remove devices.

In other words, just as on a normal disk the filesystem doesn't start at 
the beginning of the disk because the MBR is in the way, an array does 
not start at the beginning of the partition because the superblock is in 
the way.

You'll either need to use your knowledge of XFS internals to find the 
start of the filesystem, look at mdadm and work out how to read the 
superblock so it tells you, or just force-assemble the array!

But I think I'm on very safe ground saying your filesystem is safely 
there. It's just not where you think it is because you haven't grasped 
how raid works at the disk level.

Cheers,
Wol
> 
> On Sat, Nov 4, 2017 at 11:30 AM, Wols Lists <antlists@youngman.org.uk> wrote:
>> On 04/11/17 18:10, David F. wrote:
>>> Question,  We had a customer remove a drive from a NAS device that as
>>> mirrored using mdadm, the file system id for the partitions were 0xFD
>>> (linux raid automount). The put it on a USB port and booted Linux
>>> which attempts to mount any RAID devices.  The XFS had some issues, so
>>> looking at it I see some type of RAID header for MyBook:2 at offset
>>> 4K.   Searching Internet on mdadm found:
>>
>> First things first. DO NOT mount the array read/write over a USB
>> connection. There's a good chance you'll regret it (raid and USB don't
>> like each other).
>>>
>>> Version 1.2: The superblock is 4 KiB after the beginning of the device.
>>>
>>> I wouldn't think the RAID area would be available to the file system,
>>> but assuming so, there must be some type of way to find out where the
>>> real data for that went?   Or perhaps mdadm messed it up when trying
>>> to mount and the other drive didn't exist.  Here details of it.
>>
>> mdadm did exactly what it is supposed to do. A mirror with one drive is
>> degraded, so it assembled the array AND STOPPED. Once you force it past
>> this point, I think it will happily go past again no problem, but it's
>> designed to refuse to proceed with a damaged array, if the array was
>> fully okay previous time.
>>
>> So, in other words, the disk and everything else is fine.
>>
>> What's happened is that mdadm has assembled the array, realised a disk
>> is missing, AND STOPPED.
>>
>> What should happen next is that the array runs, so you need to do
>> mdadm --run /dev/md0
>> or something like that. You may well need to add the --force option.
>>
>> Finally you need to mount the array
>> mount /dev/md0 /mnt READ ONLY !!!
>> Sorry, I don't know the correct option for read only
>>
>> At this point, your filesystem should be available for access.
>> Everything's fine, mdadm is just playing it safe, because all it knows
>> is that a disk has disappeared.
>>
>> And you need to play it safe, because USB places the array in danger.
>>
>> Cheers,
>> Wol
> 
