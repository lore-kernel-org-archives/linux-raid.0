From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Advice requested
Date: Tue, 3 Nov 2015 06:45:49 -0600
Message-ID: <CAPpdf58=f7YVej5MEFgaw6KvCgn+WBcm=JSrTNbM8AixWdpa1g@mail.gmail.com>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
	<56367C33.6060703@turmel.org>
	<CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
	<5637842D.1070000@turmel.org>
	<CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
	<5637BCE4.8000006@turmel.org>
	<CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
	<5637FBAC.8000900@turmel.org>
	<CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>
	<56380690.5030600@turmel.org>
	<CAPpdf5-HbrFESY_zhfkZ4=2CtYjgO4bA4LmA+1AHkT+Gv9iY2w@mail.gmail.com>
	<56381406.7070608@turmel.org>
	<CAPpdf59EV2TfpHUiZghAfWW6qy5je686Hg_qAs4xLchrUa=G7w@mail.gmail.com>
	<5638336E.4030400@turmel.org>
	<CAPpdf5-DMFrKRiBXjstJkvqQU1KzqJoL=hfNVqTGjy2HfMcALQ@mail.gmail.com>
	<56383C64.2070807@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56383C64.2070807@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 2, 2015 at 10:47 PM, Phil Turmel <philip@turmel.org> wrote:
> On 11/02/2015 11:28 PM, o1bigtenor wrote:
>> gdisk
>>
>> n 1 2048 1923518592
>>
>> Will that change any of the data on the sectors?
>>
>> Please - - - is there any way of getting specific commands?
>
> gdisk /dev/md0
>
> {Yes, you put /dev/md0 on the gdisk command line.}
>
> then select 'n' for new partition.  It should offer to create partition
> #1.  It should offer 2048 as the starting sector.  It should offer the
> last legal sector as the ending sector.  It will probably assign type
> 8300 by default too.  All good.  Just make sure it *does* get the
> starting sector right (2048).
>
> When it gives you its prompt again, select 'p' to print it out so you
> can double check.  Then select 'w' to write the new partition table.  It
> will warn you, but yes you are sure (as long as the start sector is 2048).
>
> You will end up back at the shell prompt.  You may or may not have seen
> a partition device name in the messages.  If not, use "partprobe /dev/md0".
>
> Finally, use "dmesg |tail" to see the last few kernel messages -- the
> new device name should show up there.  Or use "blkid" to see all known
> partition names.
>
> Whatever name it is, fsck it with the '-n' option.
>
> Then mount it.
>
> Then make backups.
>

root@debianbase:/# gdisk /dev/md0
GPT fdisk (gdisk) version 1.0.0

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.

Command (? for help): n
Partition number (1-128, default 1): 1
First sector (34-3907037150, default = 2048) or {+-}size{KMGTP}: 2048
Last sector (2048-3907037150, default = 3907037150) or
{+-}size{KMGTP}: 3907037150
Current type is 'Linux filesystem'
Hex code or GUID (L to show codes, Enter = 8300): 8300
Changed type of partition to 'Linux filesystem'

Command (? for help): p
Disk /dev/md0: 3907037184 sectors, 1.8 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 1EB47793-0CDF-4E16-AE84-33EC825AC448
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 3907037150
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048      3907037150   1.8 TiB     8300  Linux filesystem

Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): Y
OK; writing new GUID partition table (GPT) to /dev/md0.
The operation has completed successfully.
root@debianbase:/# dmesg |tail
[35958.237305] JBD2: Error -5 detected when updating journal
superblock for sdh1-8.
[35958.265302] sd 16:0:0:1: [sdh] Synchronize Cache(10) failed:
Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[42828.763827] md: md0 stopped.
[42828.764985] md: bind<sdb1>
[42828.765270] md: bind<sdf1>
[42828.786394] md: raid10 personality registered for level 10
[42828.787258] md/raid10:md0: active with 2 out of 4 devices
[42828.787316] md0: detected capacity change from 0 to 2000403038208
[42828.859574]  md0:
[84855.526621]  md0: p1
root@debianbase:/# blkid
/dev/sda1: UUID="8685-1E58" TYPE="vfat"
PARTUUID="b0e65d5d-5192-4bb1-8bcc-18aaba41cc51"
/dev/sda2: UUID="86A5-6A1A" TYPE="vfat" PARTLABEL="EFI"
PARTUUID="a03a817f-e1ff-4d4c-bff2-465113366d5a"
/dev/sda3: UUID="325c280b-4a4b-420e-8ac4-82aec9db48ec" TYPE="ext2"
PARTLABEL="/boot" PARTUUID="5bd9a487-053a-454d-8db4-2451646ac2fb"
/dev/sda4: UUID="63e7d344-7e9c-443a-9c77-1fe839e694ef" TYPE="ext4"
PARTLABEL="/root" PARTUUID="17740d0d-6bcd-4155-8a9d-17260dcbe027"
/dev/sda5: UUID="1c9d8fba-dd27-4c90-a061-4300e6ff475d" TYPE="swap"
PARTLABEL="swap" PARTUUID="3215a477-3430-4cca-87f4-96d16a7a73d7"
/dev/sda6: UUID="c0ba6eb7-e64a-4b83-8ae1-98c5fd8c0837" TYPE="ext4"
PARTLABEL="/tmp" PARTUUID="037e1c13-6448-4808-b64d-d73580a20848"
/dev/sda7: UUID="6e1a5b3f-e247-4745-a648-8d570a3614c2" TYPE="ext4"
PARTLABEL="/var" PARTUUID="0d31bc6d-a7d1-458d-a32b-d824f70e091c"
/dev/sda8: UUID="ab17dd8c-07b2-45a2-9348-280a46e5b8c3" TYPE="ext4"
PARTLABEL="/usr" PARTUUID="02fd1bc8-f698-4c68-858f-b29777688f49"
/dev/sda9: UUID="7f1cf0d8-ece1-4ba2-8b15-39a51e2eef46" TYPE="ext4"
PARTLABEL="/usr/local" PARTUUID="12e6d517-798d-40d9-919f-29baafe3a0f5"
/dev/sda10: UUID="a8517954-4fae-4eac-806a-e6a8a4f470d5" TYPE="ext4"
PARTLABEL="/home" PARTUUID="3a465b4c-148d-45be-af57-bb0f7957c535"
/dev/sdb1: UUID="79baaa2f-0aa2-b9fa-18e2-ea6b6e2846b3"
UUID_SUB="a80c76db-eaea-61af-bcb9-cbbbac99e467" LABEL="debianbase:0"
TYPE="linux_raid_member" PARTUUID="000e4ced-01"
/dev/sdc1: PARTLABEL="Linux filesystem"
PARTUUID="a79c809a-0333-41d7-918a-e340febddcf4"
/dev/sde1: UUID="79baaa2f-0aa2-b9fa-18e2-ea6b6e2846b3"
UUID_SUB="cb37e722-d3a9-8f88-1343-9de2bdad9d2b" LABEL="debianbase:0"
TYPE="linux_raid_member" PARTUUID="000dc7e1-01"
/dev/sdd1: UUID="a0ce336b-35cd-4413-a1c7-e77a1a4e91a6" TYPE="ext2"
PARTUUID="000c9868-01"
/dev/sdd5: UUID="bbe77e50-0eaa-4048-934e-9f1b72b157ff" TYPE="ext4"
PARTUUID="000c9868-05"
/dev/sdd6: UUID="533f504b-30a6-4cf6-86e9-56772c87bae3" TYPE="ext4"
PARTUUID="000c9868-06"
/dev/sdd7: UUID="ff6bcbe9-f25f-4738-ba6b-5ea3c2fe0b70" TYPE="ext4"
PARTUUID="000c9868-07"
/dev/sdd8: UUID="2d0d1953-dae6-4e33-8d04-cc685e2e36fb" TYPE="ext4"
PARTUUID="000c9868-08"
/dev/sdd9: UUID="df754d9a-3dcf-470f-8e26-d38ef6f82df0" TYPE="ext4"
PARTUUID="000c9868-09"
/dev/sdd10: UUID="842d5e5f-590e-49bd-9a36-8513a2e81f8c" TYPE="swap"
PARTUUID="000c9868-0a"
/dev/sdf1: UUID="79baaa2f-0aa2-b9fa-18e2-ea6b6e2846b3"
UUID_SUB="9e749fa9-a0ef-e791-ea09-d2e272b99f6c" LABEL="debianbase:0"
TYPE="linux_raid_member" PARTUUID="0002d71f-01"
/dev/md0: PTUUID="1eb47793-0cdf-4e16-ae84-33ec825ac448" PTTYPE="gpt"
/dev/md0p1: UUID="49552036-b46f-4956-ade9-3541a3dd7f0a" TYPE="ext4"
PARTLABEL="Linux filesystem"
PARTUUID="2d6ef378-b27a-4de6-a42f-9c0a7e191a00"
root@debianbase:/# fsck -n /dev/md0p1
fsck from util-linux 2.26.2
e2fsck 1.42.13 (17-May-2015)
The filesystem size (according to the superblock) is 488379392 blocks
The physical size of the device is 488379387 blocks
Either the superblock or the partition table is likely to be corrupt!
Abort? no

/dev/md0p1 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/md0p1: 618365/122101760 files (0.2% non-contiguous),
78222096/488379392 blocks



Then I checked using my file manager program and a 2.0 TB volume is listed.
When I tried opening it

Error mounting /dev/md0p1 at
/media/xxxx/49552036-b46f-4956-ade9-3541a3dd7f0a: Command-line `mount
-t "ext4" -o "uhelper=udisks2,nodev,nosuid" "/dev/md0p1"
"/media/darald/49552036-b46f-4956-ade9-3541a3dd7f0a"' exited with
non-zero exit status 32: mount: wrong fs type, bad option, bad
superblock on /dev/md0p1,
       missing codepage or helper program, or other error

If I go back to

gdisk /dev/md0

run

n

and change the last sector to say about 2 or maybe 3 from the last number

1. will I damage something
2. is this what I should do?

as for mounting

I used to use the command

#mount /dev/md0 /home/xxxx/RAID

is that what I use for mounting?


I think that I am right close to being able to backup the files.

Any suggestions for what to do after the files are backed up - - -

Should I (after making backup copies) rebuild the array

1. just treat the disks as if they were empty
2. some other process

Thanking you for your assistance.

Dee
