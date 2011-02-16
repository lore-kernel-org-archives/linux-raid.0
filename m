From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 18:18:48 +0000
Message-ID: <4D5C1508.3040308@gmail.com>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown> <4D5A92F3.1090004@turmel.org> <4D5BD678.2050200@gmail.com> <4D5BE119.7000804@turmel.org> <4D5C0E17.3060306@gmail.com> <4D5C140F.9010301@turmel.org>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C140F.9010301@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

parted -l gives

Error: The backup GPT table is not at the end of the disk, as it should 
be.  This might mean that another operating
system believes the disk is smaller.  Fix, by moving the backup to the 
end (and removing the old backup)?
Fix/Cancel? fix
Warning: Not all of the space available to /dev/sdb appears to be used, 
you can fix the GPT to use all of the space (an
extra 421296 blocks) or continue with the current setting?
Fix/Ignore?

I'm guessing ignore ?

Simon

On 16/02/2011 18:14, Phil Turmel wrote:
> On 02/16/2011 12:49 PM, Simon McNair wrote:
>> Hi Phil,
>>   A couple of questions please.
> [trim /]
>
>>>> Simon
>>> I don't know why the serial numbers are formatted differently, but we can still tell them apart (the eight characters starting with "PAG").
>>>
>>> So, our device order in your new setup is: [ihgfmlkjbc], where /dev/sdi corresponds to the original report's /dev/sdd, which matches the sig grep in your other note.
>>>
>>> Another note:  The controller for sd[abc] is still showing ata_piix as its controller.  That means you cannot hot-plug those ports.  If you change your BIOS to AHCI mode instead of "Compatibility" or "Emulation", the full-featured ahci driver will run those ports.  Not urgent, but I highly recommend it.
>>>
>> Will do that now, before I forget
> Hot-pluggability with suitable trays is very handy! :)
>
> [trim /]
>
>>>> Error: The backup GPT table is not at the end of the disk, as it should be.  This might mean that another operating
>>>> system believes the disk is smaller.  Fix, by moving the backup to the end (and removing the old backup)?
>>>> Fix/Cancel? c
>>> The 3ware controller must have reserved some space at the end of each drive for its own use.  Didn't know it'd do that.  You will have to fix that.
>>>
>>> [trim /]
>>>
>> Do you have any suggestions on how I can fix that ?  I don't have a clue
> Just do 'parted /dev/sd?' and on the ones it offers to fix, say yes.  Then request 'unit s' and 'print' to verify that it is correct.
>
> [trim /]
>
>> when I was trying to figure out the command for this using 'man parted' I came across this:
>> " rescue start end
>>                       Rescue  a  lost  partition  that was located somewhere between start and end.  If a partition is
>>                       found, parted will ask if you want to create an entry for it in the partition table."
>> Is it worth trying ?
> Nah.  That's for when you don't know exactly where the partition is.  We know.
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
> Only recreate the partition tables where you have to, i.e., the 'Fix' option above didn't work.  And don't specify a filesystem.
>
> Probably just /dev/sdh and /dev/sdi.  Like so, though:
>
> parted -s /dev/sdh mklabel gpt mkpart primary 2048s 1953101823s set 1 raid on
> parted -s /dev/sdi mklabel gpt mkpart primary 2048s 1953101823s set 1 raid on
>
>> I'm guessing the backups that I want to do can wait until any potential fsck ?
> Do an 'fsck -N' first, and if it passes, or has few errors, mount the filesystem readonly and grab your backup.  Then let fsck have at it for real.  If anything gets fixed, compare your backup from the read-only fs to the fixed fs.
>
> Given your flaky old controller, I expect there'll be *some* problems.
>
>> sorry if the questions are dumb but I'm not sure what I'm doing and I'd rather ask more questions than fewer and understand the implications of what I'm doing.
> Oh, no.  You are right to be paranoid.  If anything looks funny, stop.
>
> Phil
