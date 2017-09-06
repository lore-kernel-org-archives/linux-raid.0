From: David Mitchell <mr.david.mitchell@gmail.com>
Subject: Re: Superblock Missing
Date: Tue, 5 Sep 2017 23:07:40 -0400
Message-ID: <CAANkkp+eDBMuTgwmTOhA1yeynvXHX98ORrYdDiR=XGqG8baQjw@mail.gmail.com>
References: <CAANkkp+3WwZvKu60LkU_0VpxZvZuNrrE=qDt=4DPc80AO+sgEg@mail.gmail.com>
 <20170902014333.GA26507@metamorpher.de> <CAANkkpK6jeFKr-Tz2Fzq-CTey0GJRmERy0W+DBHMVJct2JYfUQ@mail.gmail.com>
 <20170902164906.GA6823@metamorpher.de> <CAANkkp+DVzhPHEtMhmagSSO+J9cF3YwENADqCqBdXphsFE+Pmg@mail.gmail.com>
 <20170904154947.GA5263@metamorpher.de> <CAANkkp+tq2tCjgiB-1aE3zw-MZgaANmYP6W6JHNUt-7z=6WnXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANkkp+tq2tCjgiB-1aE3zw-MZgaANmYP6W6JHNUt-7z=6WnXA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

SUCCESSFUL RECOVERY!

@Andreas Klauer you are the man!    A huge THANK YOU for taking the
time to review my
issue.   I really appreciate your help.  While I do back up there were
some recent pictures of my children that had not been backed up yet.
Thank you!

Recreating the array with a different drive order fixed my problem,
100% recovered!

After setting up overlays per your instructions:

# mdadm --stop /dev/md1
mdadm: stopped /dev/md1

# mdadm --assemble --force /dev/md1 /dev/mapper/sde1 /dev/mapper/sdc1
/dev/mapper/sdd1
mdadm: /dev/md1 has been started with 3 drives.

# mount /dev/md1 /mnt/raid/
mount: wrong fs type, bad option, bad superblock on /dev/md1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so.

# mdadm --stop /dev/md1
mdadm: stopped /dev/md1

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
unused devices: <none>

# mdadm --create --verbose --assume-clean  /dev/md1 --level=5
--raid-devices=3 /dev/mapper/sde1 /dev/mapper/sdc1 /dev/mapper/sdd1

/ NOTE the order changed from C,D,E (not working) to E, C, D (working)

mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: /dev/mapper/sde1 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Sat Aug 26 16:21:20 2017
mdadm: partition table exists on /dev/mapper/sde1 but will be lost or
       meaningless after creating array
mdadm: /dev/mapper/sdc1 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Sat Aug 26 16:21:20 2017
mdadm: partition table exists on /dev/mapper/sdc1 but will be lost or
       meaningless after creating array
mdadm: /dev/mapper/sdd1 appears to be part of a raid array:
       level=raid5 devices=3 ctime=Sat Aug 26 16:21:20 2017
mdadm: size set to 3900571648K
mdadm: automatically enabling write-intent bitmap on large array
Continue creating array? Y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
# mount /dev/md1 /mnt/raid/
# ls /mnt/raid/
kvm  lost+found  media  my-docs  test  tmp

# umount /mnt/raid
# fsck.ext4 -f -n /dev/md1
e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/md1: 224614/487571456 files (0.9% non-contiguous),
690410561/1950285824 blocks
virtual mnt # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
md1 : active raid5 dm-1[2] dm-0[1] dm-2[0]
      7801143296 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 0/30 pages [0KB], 65536KB chunk

unused devices: <none>

Sincerely,

David Mitchell


On Mon, Sep 4, 2017 at 1:56 PM, David Mitchell
<mr.david.mitchell@gmail.com> wrote:
> @Andreas Klauer a huge THANK YOU for taking the time to review my
> issue.   I really appreciate your help.
>
> Sincerely,
>
> David Mitchell
>
>
> On Mon, Sep 4, 2017 at 11:49 AM, Andreas Klauer
> <Andreas.Klauer@metamorpher.de> wrote:
>> On Sun, Sep 03, 2017 at 11:35:25PM -0400, David Mitchell wrote:
>>> I really do NOT remember running the  --create command.
>>
>> There is no other explanation for it. It has happened somehow.
>>
>>> The pictures over 512k don't display correctly.
>>
>> So not only/necessarily a wrong data offset, but also wrong drive order.
>>
>>> At this point I'm hoping for help on next steps in recovery/troubleshooting.
>>
>> 1. Use overlays.
>>
>> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
>>
>>    That way you can safely experiment and create RAID with
>>    different settings. (Use --assume-clean and/or missing)
>>
>> 2. Check first 128M of each drive (your current data offset).
>>    See if you can find a valid filesystem header anywhere.
>>    That way you could determine the correct data offset.
>>
>> 3. Find a JPEG header (any known file type, like a 2-3M file)
>>    and look at the other drives for the same offset. You should be
>>    able to deduce RAID layout, chunksize, drive order from that.
>>
>> Instead of 3) you can also simply trial and error with overlays
>> until you find a setting that allows photorec to find larger files intact.
>>
>> The resync might not necessarily have damaged your data. If the offsets
>> were the same and the RAID level was the same, and the drives were in
>> sync, a resync even with wrong settings would still produce the same data.
>> For XOR, a ^ b = c and b ^ a = c so switching the drives does no damage
>> provided you don't write anything else...
>>
>> Regards
>> Andreas Klauer
