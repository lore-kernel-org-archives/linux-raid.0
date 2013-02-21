From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 18:17:41 +0100
Message-ID: <512656B5.4090505@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51265132.7070706@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 21.02.2013 17:54, schrieb Phil Turmel:
> On 02/21/2013 11:51 AM, Stone wrote:
>
>> the dead-key was pressed
>> here the output:
>> root@bender:~# dd if=/dev/zero bs=1024 count=12 seek=1073006628
>> of=/dev/sdc1
>> 12+0 records in
>> 12+0 records out
>> 12288 bytes (12 kB) copied, 0,00019109 s, 64,3 MB/s
>> root@bender:~# dd if=/dev/zero bs=1024 count=12 seek=1073101016
>> of=/dev/sdc1
>> 12+0 records in
>> 12+0 records out
>> 12288 bytes (12 kB) copied, 0,00017799 s, 69,0 MB/s
>> root@bender:~# dd if=/dev/zero bs=1024 count=8 seek=1335739456 of=/dev/sdc1
>> 8+0 records in
>> 8+0 records out
>> 8192 bytes (8,2 kB) copied, 0,000159338 s, 51,4 MB/s
>> root@bender:~# dd if=/dev/zero bs=1024 count=8 seek=1346771164 of=/dev/sdc1
>> 8+0 records in
>> 8+0 records out
>> 8192 bytes (8,2 kB) copied, 0,000161977 s, 50,6 MB/s
>> root@bender:~# dd if=/dev/zero bs=1024 count=8 seek=1348581732 of=/dev/sdc1
>> 8+0 records in
>> 8+0 records out
>> 8192 bytes (8,2 kB) copied, 0,000157825 s, 51,9 MB/s
> Very good.
>
>> now i boot my server with a live cd and recreate my raid.
>> if this was successfully i open the LUKS and check it.
>> here my commands for this step:
>> mdadm --create /dev/md2 --assume-clean --verbose --level=5
>> --raid-devices=4 /dev/sdc1 /dev/sdd1 missing /dev/sdf1
>> cryptsetup luksOpen /dev/md2 md2_nas
>> fsck -n /dev/md2
> Looks good.
>
> Phil
i created the raid successfulle and the LUKS is open!
this is the output of my fsck
fsck -n /dev/mapper/md2_nas
fsck from util-linux 2.19.1
e2fsck 1.41.14 (22-Dec-2010)
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open 
/dev/mapper/md2_nas

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
     e2fsck -b 8193 <device>
