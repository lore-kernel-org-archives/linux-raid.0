From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 18:35:29 +0100
Message-ID: <5E95F461.50209@youngman.org.uk>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
 <13a3bc12-67f7-46d5-7e6a-c6880ace4b1c@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13a3bc12-67f7-46d5-7e6a-c6880ace4b1c@peter-speer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/04/20 16:12, Stefanie Leisestreichler wrote:
> 
> On 14.04.20 16:20, Wols Lists wrote:
>> okay. sda1 is vfat for EFI and is your /boot. configure sdb the same,
>> and you'll need to manually copy across every time you update (or make
>> it a v0.9/v1.0 raid array and only change it from inside linux - tricky)

> If I would like to stay with my intial thought and use GRUB, does this
> mean, I have to have one native partition for the UEFI System Partition
> formated with vfat on each disk? If this works and I will create an raid
> array (mdadm --create ... level=1 /dev/sda1 /dev/sda2) from these 2
> partitions, will I still have the need to cross copy after a kernel
> update or not?
> 
Everything else is mirrored - you should mirror your boot setup ... you
don't want disk 0 to die, and although (almost) everything is there on
disk 1 you can't boot the system because grub/efi/whatever isn't there...

The crucial question is whether your updates to your efi partition
happen under the control of linux, or under the control of efi. If they
happen at the linux level, then they will happen to both disks together.
If they happen at the efi level, then they will only happen to disk 0,
and you will need to re-sync the mirror.
>>
>> sda2 - swap. I'd make its size equal to ram - and as I said, same on sdb
>> configured in linux as equal priority to give me a raid-0.

> Thanks for this tip, I would prefer swap and application safety which
> comes with raid1 in this case. Later I will try to optimize swappiness.
> 
I prefer swap to be at least twice ram. A lot of people think I'm daft
for that, but it always used to be the rule things were better that way.
It's been pointed out to me that this can be used as a denial of service
(a fork bomb, for example, will crucify your system until the OOM killer
takes it out, which will take a LOOONNG time with gigs of VM). Horses
for courses.
>>
>> sda3 / sdb3 - the remaining space, less your 100M, raided together. You
>> then sit lvm on top in which you put your remaining volumes, /, /home,
>> /var/lib/mysql and /var/lib/images.

> OK. Does this mean that I have to partition my both drives first and
> after that create the raid arrays, which will end in /dev/md0 for ESP
> (mount point /boot), /dev/md1 (swap), /dev/md2 for the rest?

Yup. Apart from the fact that they will probably be 126, 125 and 124 not
0, 1, 2. And if I were you I'd name them, for example EFI, SWAP, MAIN or
LVM.
> 
> What Partition Type do I have to use for /dev/sd[a|b]3? Will it be LVM
> or RAID?
> 
I'd just use type linux ...
>>
>> Again, personally, I'd make /tmp a tmpfs rather than a partition of its
>> own, the spec says that the system should*expect*  /tmp to disappear at
>> any time and especially on reboot... while tmpfs defaults to half ram,
>> you can specify what size you want, and it'll make use of your swap
>> space.
> Agreed, no LV for /tmp.
> 
Sounds like you probably know this, but remember that /tmp and /var/tmp
are different - DON'T make /var/tmp a tmpfs, and use a cron job to clean
that - I made that mistake early on ... :-)

You found the kernel raid wiki, did you? You've read
https://raid.wiki.kernel.org/index.php/Setting_up_a_%28new%29_system and
the pages round it? It's not meant to be definitive, but it gives you a
lot of ideas. In particular, dm-integrity. I intend to play with that a
lot as soon as I can get my new system up and running, when I'll
relegate the old system to a test-bed.

Cheers,
Wol
