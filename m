From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Alignment of RAID on specific boundary
Date: Mon, 4 Jan 2010 21:30:33 +0200
Message-ID: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello and happy new year.

I browsed the archive to find similar threads and learned valuable info
but every thread i found was about aligning something on top of raid
(mostly lvm) not aligning the raid itself. I apologize if it is already answered
and i missed it.

A friend of mine has two SSDs and wants a setup of RAID1->LUKS->LVM.
I have done this setup before but never bothered to align them.
Instead of RAID1 i thought to setup RAID10,f2. I know it cannot be grown
but until the price of SSDs are lowered enough for him to buy larger ones
the grow support will probably be implemented.

I have tried the procedure in Virtualbox first to make sure i don't
make any mistakes.
Here are the details:

Disk /dev/sda: 83886080 sectors, 40.0 GiB

No   Start          End      Size            Name
1         40           255    108.0 KiB     BIOS boot partition
2       256     262399    128.0 MiB     Linux RAID
3 262400 83886046    39.9 GiB      Linux RAID

I thought to align partitions on a 128K boundary to match the erase block,
so i aligned them to 256 sectors. The disks use a GPT label.
GPT doesn't provide a GUID for 0xDA Non-FS Data so i used Linux RAID.
I don't think there is a danger of a rescue cd to mess with the
partition because
few if any know about GPT. Otherwise, i can also use Linux Reserved.

I will install LILO but i created the BIOS boot partition in case he
later wants to use
grub2. The 128MB array will be RAID1 /boot and uses 0.90 metadata because
both lilo and grub2 can't boot from v1 metadata (unless the grub2 wiki is old).

My main concern is to align the large array.

% mdadm -V
mdadm - v3.1.1 - 19th November 2009

% mdadm -C /dev/md1 -l 10 -e 1.1 -p f2 -n 2 --name=vbmd /dev/sd[ab]3
% mdadm -E /dev/sda3
Version : 1.1
Avail Dev Size : 83623511
Array Size : 83621888
Used Dev Size : 83621888
Data Offset : 136 sectors
Super Offset : 0 sectors
Layout : far=2
Chunk Size : 512K

So i have 2 disks with 512K chunk (which is divisable by 128K so everything
is fine) so a full stripe is 1MB.

% cryptsetup -c aes-xts-plain -s 512 --align-payload=2048 luksFormat /dev/md1
% cryptsetup luksDump /dev/md1
Payload offset: 4096


% cryptsetup luksOpen /dev/md1 vbcrypt
% pvcreate /dev/mapper/vbcrypt
% pvs -o +pe_start
1st PE 1.00m

As you see LUKS payload starts at 2MB and LVM payload starts at 1MB offset.
I will use 16MB extent size in LVM which is divisible with the 1MB stripe.
So if i am not mistaken, everything is correctly aligned on top of RAID.

The only problem i have is the RAID alignment. "-D /dev/md1"
doesn't mention anything but "-E /dev/sda3" mentions the 136 sectors
data offset. Does that mean that the actual RAID data start at the 136
sectors ? If yes then the RAID isn't aligned with the SSD which in turn
messes every alignment on top of it. I tried to create the array with
an internal bitmap so that the bitmap occupies some space thus
increasing the offset but it didn't work. The offset is still 136 sectors.

Is there a way to make the RAID data start at a particular offset ?
(In my case 512 sectors) ?

If my thoughts are flawed then please correct me.

Thank you for your time.
