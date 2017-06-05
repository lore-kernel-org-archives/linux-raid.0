From: Paul Tonelli <paul@tonel.li>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Tue, 6 Jun 2017 01:24:41 +0200
Message-ID: <dfa4dd0d-c68a-4e1b-aac7-649f7f1a72f6@tonel.li>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
 <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
 <20170603232919.GA17108@metamorpher.de>
 <b8b6eb18-2952-86ee-5329-9e4f4c406c3d@tonel.li>
 <20170605092454.GA3651@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170605092454.GA3651@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again Andreas (and anybody else reading)

On 06/05/2017 11:24 AM, Andreas Klauer wrote:
> On Mon, Jun 05, 2017 at 12:58:03AM +0200, Paul Tonelli wrote:
>> I  did find this one at that exact offset 26096 = (133169664 - 512)/512
> 26096->260096? Okay.
Yes, sorry this was a typo, the superblock was exactly where you 
expected it, I did the following procedure:

```
export $DEVICES="/dev/sdc /dev/sdd /dev/sdb"
/root/create_overlay.sh
mdadm --create /dev/md0 --level=5 --assume-clean --raid-devices=3 
missing /dev/mapper/sdd /dev/mapper/sdb
mdadm --add /dev/md0  /dev/mapper/sdc
#sleep 30s
mdadm --stop /dev/md0
xxd -u /dev/mapper/sdc | grep  -C 3 'LABELONE'
 >7f001e0: 0000 0000 0000 0000 0000 0000 0000 0000 ................
 >7f001f0: 0000 0000 0000 0000 0000 0000 0000 0000 ................
 >7f00200: 4C41 4245 4C4F 4E45 0100 0000 0000 0000 LABELONE........
 >7f00210: B5E5 02EA 2000 0000 4C56 4D32 2030 3031  .... ...LVM2 001
 >7f00220: 5132 5A33 3244 6979 506A 3951 5970 7558 Q2Z32DiyPj9QYpuX
 >7f00230: 4243 7130 3265 7338 514B 3665 7176 3464 BCq02es8QK6eqv4d
```

I have let it run for a longer time (10 min) and it does not find 
another LABELONE after that. (I also tried to find LABELONE on the other 
disks without success).


>> Now, after doing a pvcreate and a vgcfgrestore ...
> Should not be necessary if the data on two drives was okay?
> You did leave the dd-overwritten drive out as missing, right?
> Do you have the correct disk order and chunk size and offset?
I believe you are right, the issue is still the raid: I have tried 
photorec and most files I have opened look like they have been 
truncated. I have checked again the commands used to build the raid, (I 
had initially extracted them from bash_history, but I also have a record 
with timestamps in /var/log/auth.log because of sudo).

and all the commands match ( I have put all the commands used on the 
raid at the end of the mail )
> You have to be 140% sure the RAID itself is running correctly,
> otherwise all other steps are bound to fail.
>
> If you run photorec on the RAID and it manages to recover
> a file that is larger than number of drives * chunk size
> and intact, you can have some confidence the RAID is okay
> in terms of disk order and chunk size - the offset may
> still be off by multiple of stripe alignment but if the
> offset is correct too, file -s /dev/md0 should say LVM PV
> in your case.
Photorec does not: I get only small files when I use photorec. The only 
"big" files it recovers are tar (and I believe that is because it does 
not check integrity of the files). I have left it running for ~10G of 
files were recovered.

 From what I understand, finding the "LABELONE" at the correct position 
shows:

- apart from the raid superblock, the disks I use (sdd and sdb) have not 
been erased  (as sdc is rebuilt from xor)
- the offset to build the raid is correct (I find all ext4 backup 
superblock when doing the testdisk / checking with e2fsck -b XXX ), with 
the issue of the 640 ext4 chunk offset.
- the first disk of the array is sdc (as the "LABELONE" can only be 
found on this disk)

so I may need to check the other parame

  /dev/md0 should say LVM PV

I believe my best option is to do a script to explore several parameters 
using the overlay and see if one finds the correct data. I would use as 
parameters:
- disk order
- raid chunk size

Would you test any other parameters ?

In the things I have tried, I used the offset option on an losetup to 
align the backup superblocks from the logical volume, e2fsck then runs 
directly, but it then refuse to continue because of the wrong volume 
size, so I do not think this is the right solution, and the 640 ext4 
offset cannot easily be added to lvm, I agree with your previous comment 
that it is still on the raid level there are issues.

Thanks (again) for reading me to this point, I will still happily take 
any advice, and update once I have written and run my script.

Dump of raid building commands
=====================

part 1
---------

sudo commands which created the array:

```
May 16 17:38:47 redacted sshd[10978]: pam_unix(sshd:session): session 
opened for user skoos by (uid=0)
May 16 17:38:47 redacted systemd-logind[1071]: New session 754 of user 
skoos.
May 16 17:41:29 redacted sudo: user : TTY=pts/83 ; PWD=/srv/data ; 
USER=root ; COMMAND=/usr/bin/apt-get install mdadm
May 16 17:41:29 redacted sudo: pam_unix(sudo:session): session opened 
for user root by user(uid=0)
May 16 17:41:45 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 16 17:41:48 redacted sudo: user : TTY=pts/83 ; PWD=/srv/data ; 
USER=root ; COMMAND=/sbin/mdadm --create --verbose --force 
--assume-clean /dev/md0 -
-level=5 --raid-devices=2 /dev/sdb /dev/sdc
May 16 17:41:48 redacted sudo: pam_unix(sudo:session): session opened 
for user root by user(uid=0)
May 16 17:42:08 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 16 17:42:10 redacted sudo: user : TTY=pts/83 ; PWD=/srv/data ; 
USER=root ; COMMAND=/sbin/mdadm --create --verbose --force 
--assume-clean /dev/md0 -
-level=5 --raid-devices=2 /dev/sdb /dev/sdc
May 16 17:42:10 redacted sudo: pam_unix(sudo:session): session opened 
for user root by user(uid=0)
May 16 17:42:13 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 16 17:42:43 redacted sudo: user : TTY=pts/83 ; PWD=/srv/data ; 
USER=root ; COMMAND=/sbin/pvcreate /dev/md0
May 16 17:42:43 redacted sudo: pam_unix(sudo:session): session opened 
for user root by user(uid=0)
May 16 17:42:44 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 16 17:42:49 redacted sudo: user : TTY=pts/83 ; PWD=/srv/data ; 
USER=root ; COMMAND=/sbin/vgdisplay
May 16 17:42:49 redacted sudo: pam_unix(sudo:session): session opened 
for user root by user(uid=0)
May 16 17:42:49 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 16 17:43:02 redacted sudo: user : TTY=pts/83 ; PWD=/srv/data ; 
USER=root ; COMMAND=/sbin/vgcreate vg0 /dev/md0
May 16 17:43:02 redacted sudo: pam_unix(sudo:session): session opened 
for user root by user(uid=0)
May 16 17:43:02 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 16 17:43:23 redacted sudo: user : TTY=pts/83 ; PWD=/srv/data ; 
USER=root ; COMMAND=/sbin/lvcreate -L 2.6T -n data /dev/vg0
May 16 17:43:23 redacted sudo: pam_unix(sudo:session): session opened 
for user root by user(uid=0)
May 16 17:43:23 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 16 17:43:32 redacted sudo: user : TTY=pts/83 ; PWD=/srv/data ; 
USER=root ; COMMAND=/sbin/mkfs.ext4 /dev/vg0/data
May 16 17:43:32 redacted sudo: pam_unix(sudo:session): session opened 
for user root by user(uid=0)
May 16 17:43:48 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 16 17:45:34 redacted sudo: user : TTY=pts/83 ; PWD=/srv/data ; 
USER=root ; COMMAND=/bin/mount /dev/vg0/data /mnt/data
May 16 17:45:34 redacted sudo: pam_unix(sudo:session): session opened 
for user root by user(uid=0)
May 16 17:45:35 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 16 17:46:08 redacted sudo: user : TTY=pts/103 ; PWD=/mnt/data ; 
USER=root ; COMMAND=/usr/bin/rsync -avH /srv/data/ /mnt/data
```

part 2
---------

command to rebuild the array after reboot (the array was not detected 
any longer after reboot, but once the following command was run, it 
mounted fine):

```
May 23 13:23:55 redacted sudo: user : TTY=pts/1 ; PWD=/home/user ; 
USER=root ; COMMAND=/sbin/mdadm --create --verbose /dev/md0 --level=5 
--raid-devices=2 /dev/sdb /dev/sdc
```

commands used to grow with third disk

```
May 24 21:04:10 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/mdadm --add /dev/md0 /dev/sdd
May 24 21:04:10 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 24 21:04:10 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 24 21:04:15 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/mdadm /dev/md0
May 24 21:04:15 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 24 21:04:15 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 24 21:04:20 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/mdadm /dev/md0 --detail
May 24 21:04:20 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 24 21:04:20 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 24 21:04:26 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/mdadm --detail /dev/md0
May 24 21:04:26 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 24 21:04:26 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 24 21:04:46 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/mdadm --gros /dev/md0 /dev/sdd
May 24 21:04:46 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 24 21:04:46 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 24 21:04:49 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/mdadm --grow /dev/md0 /dev/sdd
May 24 21:04:49 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 24 21:04:49 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 24 21:05:16 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/mdadm --grow --raid-devices=3 /dev/md0
May 24 21:05:16 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 24 21:05:17 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 24 21:05:19 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/mdadm --detail /dev/md0
May 24 21:05:19 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 24 21:05:19 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 24 21:05:41 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/mdadm --detail /dev/md0
```

part 3
---------

commands used to resize after adding the third disk

```
May 29 09:45:20 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/mdadm --detail /dev/md0
May 29 09:45:20 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 29 09:45:21 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 29 09:45:37 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/lvextend -L +500G /dev/vg0/data
May 29 09:45:37 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 29 09:45:38 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 29 09:45:43 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/resize2fs /dev/vg0/data
May 29 09:45:43 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 29 09:45:49 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 29 09:46:02 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/lvextend -L +500G /dev/vg0/data
May 29 09:46:02 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 29 09:46:03 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 29 09:46:05 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/resize2fs /dev/vg0/data
May 29 09:46:05 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 29 09:46:12 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 29 09:46:14 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/lvextend -L +500G /dev/vg0/data
May 29 09:46:14 redacted sudo: pam_unix(sudo:session): session opened 
for user root by (uid=0)
May 29 09:46:15 redacted sudo: pam_unix(sudo:session): session closed 
for user root
May 29 09:46:16 redacted sudo:     root : TTY=pts/30 ; PWD=/root ; 
USER=root ; COMMAND=/sbin/resize2fs /dev/vg0/data
```

