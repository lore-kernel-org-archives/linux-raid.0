From: Sam Hurst <sam@sam-hurst.co.uk>
Subject: RAID wiped superblock recovery
Date: Sun, 10 May 2020 11:50:57 +0100
Message-ID: <922713c5-0cc1-24cb-14a6-9de7db631f98@sam-hurst.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

** TL;DR: Preamble for first three paragraphs - issue meat at para 4 **

I have a fairly long lived array that once started life as a 4 disk 
RAID5, had a disk replaced, and recently I've made it larger by adding 
three new disks and changing it to a RAID6 array. However, I've hit an 
issue with these three new drives.

The original RAID was set up using the raw block devices as opposed to a 
partition on the disk, and I did the same with the three new drives. 
However, these "new" drives had previously been in a machine where they 
had GPT partition tables. I hadn't thought anything of it, as I figured 
that adding the new drives to the array would wipe everything that 
already existed.

However, the backup GPT table was not wiped from the end of the disk. We 
recently discovered a peculiarity [1] with ASRock motherboard firmware 
that tries to be helpful and repair what it thinks might be a damaged 
GPT if it can find a valid one at the end of a disk on boot. So when I 
recently had to shut down the machine to replace a poorly UPS battery, 
on boot my array didn't come up.

So, I now have three drives with a wiped superblock. I'm fairly certain 
it hasn't wiped anything else, hex dumping the drives looks like the 
data all begins at the same place. First we tried recreating the 
superblocks by hand, but that didn't work. All the different 
combinations of --assemble I've tried haven't been much help, as it 
always ends the same way:

root@toothless:~# mdadm --assemble --force /dev/md127 $OVERLAYS
mdadm: failed to add /dev/mapper/sdf to /dev/md127: Invalid argument
mdadm: failed to add /dev/mapper/sdg to /dev/md127: Invalid argument
mdadm: failed to add /dev/mapper/sdh to /dev/md127: Invalid argument
mdadm: failed to RUN_ARRAY /dev/md127: Input/output error
root@toothless:~# dmesg -T | grep sdf
[Sun May 10 09:57:04 2020] md: invalid superblock checksum on sdf
[Sun May 10 09:57:04 2020] md: sdf does not have a valid v1.2 
superblock, not importing!

So I've come to the conclusion that the only way forward is to use 
`mdadm --create` and hope I get the array back that way, with new 
superblocks. I've found a Stack Overflow discussion where someone 
experimented with erasing superblocks and rebuilding, and have been 
trying to follow that [2], combined with the instructions on the Linux 
RAID wiki for using overlays to protect the underlying disk [3].

However, it's my understanding that you need to add these disks in the 
correct order - and given I have 7 disks, that's 5040 possible 
permutations! The original four disks show their device roles, so I'm 
/assuming/ that's the order in which they need adding:

/dev/sda:
    Device Role : Active device 0
/dev/sdb:
    Device Role : Active device 2
/dev/sdc:
    Device Role : Active device 1
/dev/sdd:
    Device Role : Active device 3
/dev/sdf:
    Device Role : spare
/dev/sdg:
    Device Role : spare
/dev/sdh:
    Device Role : spare

So I've tried all six permutations of the devices showing as "spare" at 
the end and I can never get a sensible filesystem out when I do a --create.

Does anyone have any other ideas, or can offer some wisdom into what to 
do next? Otherwise I'm writing a shell script to test all 5040 
permutations...


Best Regards,
Sam



[1]: 
http://forum.asrock.com/forum_posts.asp?TID=10174&title=asrock-motherboard-destroys-linux-software-raid

[2]: 
https://serverfault.com/questions/347606/recover-raid-5-data-after-created-new-array-instead-of-re-using/347786#347786

[3]: https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID
