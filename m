From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Sat, 19 Feb 2011 08:49:09 +0000
Message-ID: <AANLkTimjQkX+uLstC-xc_rnHzw3dU7-T7c8dOjvW67Zk@mail.gmail.com>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5BD678.2050200@gmail.com>
	<4D5BE119.7000804@turmel.org>
	<4D5C0E17.3060306@gmail.com>
	<4D5C140F.9010301@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C140F.9010301@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hot plug isn't a problem, I have two supermicro CSE-M35T1 's.

It's wierd though that the drive order has changed so much because I
plugged the sata ports in to the board in the same order as the 3ware
card. i.e.

port
0->0
1->1
2->2
3->3
4->4
5->5
6->6
7->7
8->m/b 7
9->m/b 8

maybe it's the way linux/udev allocated them...

one last thing:  Is echo 1 > /sys/block/sda/device/delete the correct
way to stop a AHCI SATA device ?

cheers
Simon

On 16 February 2011 18:14, Phil Turmel <philip@turmel.org> wrote:
> On 02/16/2011 12:49 PM, Simon McNair wrote:
>> Hi Phil,
>> =A0A couple of questions please.
>
> [trim /]
>
>>>> Simon
>>> I don't know why the serial numbers are formatted differently, but =
we can still tell them apart (the eight characters starting with "PAG")=
=2E
>>>
>>> So, our device order in your new setup is: [ihgfmlkjbc], where /dev=
/sdi corresponds to the original report's /dev/sdd, which matches the s=
ig grep in your other note.
>>>
>>> Another note: =A0The controller for sd[abc] is still showing ata_pi=
ix as its controller. =A0That means you cannot hot-plug those ports. =A0=
If you change your BIOS to AHCI mode instead of "Compatibility" or "Emu=
lation", the full-featured ahci driver will run those ports. =A0Not urg=
ent, but I highly recommend it.
>>>
>> Will do that now, before I forget
>
> Hot-pluggability with suitable trays is very handy! :)
>
> [trim /]
>
>>>> Error: The backup GPT table is not at the end of the disk, as it s=
hould be. =A0This might mean that another operating
>>>> system believes the disk is smaller. =A0Fix, by moving the backup =
to the end (and removing the old backup)?
>>>> Fix/Cancel? c
>>> The 3ware controller must have reserved some space at the end of ea=
ch drive for its own use. =A0Didn't know it'd do that. =A0You will have=
 to fix that.
>>>
>>> [trim /]
>>>
>> Do you have any suggestions on how I can fix that ? =A0I don't have =
a clue
>
> Just do 'parted /dev/sd?' and on the ones it offers to fix, say yes. =
=A0Then request 'unit s' and 'print' to verify that it is correct.
>
> [trim /]
>
>> when I was trying to figure out the command for this using 'man part=
ed' I came across this:
>> " rescue start end
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Rescue =A0a =A0lost =A0pa=
rtition =A0that was located somewhere between start and end. =A0If a pa=
rtition is
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0found, parted will ask if=
 you want to create an entry for it in the partition table."
>> Is it worth trying ?
>
> Nah. =A0That's for when you don't know exactly where the partition is=
=2E =A0We know.
>
>> I originally created the partitions like so:
>> parted -s /dev/sdb rm 1
>> parted -s /dev/sdb mklabel gpt
>> parted -s --align optimal /dev/sdb mkpart primary ext4 .512 100%
>> parted -s /dev/sdb set 1 raid on
>> parted -s /dev/sdb align-check optimal 1
>>
>> so to recreate the above I would do:
>> parted -s /dev/sdb mkpart primary ext4 2048s 1953101823s
>> parted -s /dev/sdc mkpart primary ext4 2048s 1953101823s
>> parted -s /dev/sdf mkpart primary ext4 2048s 1953101823s
>> parted -s /dev/sdg mkpart primary ext4 2048s 1953101823s
>> parted -s /dev/sdh mkpart primary ext4 2048s 1953101823s
>> parted -s /dev/sdi mkpart primary ext4 2048s 1953101823s
>> parted -s /dev/sdj mkpart primary ext4 2048s 1953101823s
>> parted -s /dev/sdk mkpart primary ext4 2048s 1953101823s
>> parted -s /dev/sdl mkpart primary ext4 2048s 1953101823s
>> parted -s /dev/sdm mkpart primary ext4 2048s 1953101823s
>
> Only recreate the partition tables where you have to, i.e., the 'Fix'=
 option above didn't work. =A0And don't specify a filesystem.
>
> Probably just /dev/sdh and /dev/sdi. =A0Like so, though:
>
> parted -s /dev/sdh mklabel gpt mkpart primary 2048s 1953101823s set 1=
 raid on
> parted -s /dev/sdi mklabel gpt mkpart primary 2048s 1953101823s set 1=
 raid on
>
>> I'm guessing the backups that I want to do can wait until any potent=
ial fsck ?
>
> Do an 'fsck -N' first, and if it passes, or has few errors, mount the=
 filesystem readonly and grab your backup. =A0Then let fsck have at it =
for real. =A0If anything gets fixed, compare your backup from the read-=
only fs to the fixed fs.
>
> Given your flaky old controller, I expect there'll be *some* problems=
=2E
>
>> sorry if the questions are dumb but I'm not sure what I'm doing and =
I'd rather ask more questions than fewer and understand the implication=
s of what I'm doing.
>
> Oh, no. =A0You are right to be paranoid. =A0If anything looks funny, =
stop.
>
> Phil
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
