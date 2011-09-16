From: Alex <mysqlstudent@gmail.com>
Subject: Re: Converting RAID1 to RAID5
Date: Fri, 16 Sep 2011 09:56:58 -0400
Message-ID: <CAB1R3sj7tPR-N91rJmrVOv1YqwpmC=E=zVxNmjCNYzKsS7mr9A@mail.gmail.com>
References: <CAB1R3si_QAtOwfzmYkrUz=+xPO7zSMoZEpO5+oEdXvbUnR1zzw@mail.gmail.com>
	<20110911055703.73deb44d@notabene.brown>
	<CAB1R3siia=7u0fa=9Z02kXANW6z=KzRD2Fqfz9+e6=1Q5F9HPw@mail.gmail.com>
	<20110916055727.2cd356cc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916055727.2cd356cc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

>> I partitioned a third disk in the same way as the other two, and
>> successfully added them to their existing respective volumes as
>> spares.
>>
>> I was able to grow md0, which is mounted on /boot, and it resynced i=
t
>> and successfully converted it to RAID5.
>>
>> When I try to grow the other two partitions (/ and /home), it fails
>> with device busy:
>>
>> # mdadm --grow /dev/md2 --level=3D5 --raid-devices=3D3
>> mdadm: level of /dev/md2 changed to raid5
>> mdadm: Need to backup 128K of critical section..
>> mdadm: Cannot set device shape for /dev/md2: Device or resource busy
>> =A0 =A0 =A0 =A0Bitmap must be removed before shape can be changed
> =A0 =A0 =A0 =A0 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> mdadm: aborting level change
>>
>> # cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md2 : active raid1 sdc3[2](S) sda3[0] sdb3[1]
>> =A0 =A0 =A0 186366908 blocks super 1.1 [2/2] [UU]
>> =A0 =A0 =A0 bitmap: 1/2 pages [4KB], 65536KB chunk
>>
>> md1 : active raid1 sdc2[2](S) sda2[0] sdb2[1]
>> =A0 =A0 =A0 51198908 blocks super 1.1 [2/2] [UU]
>> =A0 =A0 =A0 bitmap: 1/1 pages [4KB], 65536KB chunk
>
> You need to remove those bitmaps first. =A0Put them back after the re=
shape
> completes.
> (mdadm --grow --bitmap=3Dnone ; mdadm --grow --bitmap=3Dinternal)

Okay, great. Didn't see this documented in this way in the man page.

=46or completeness, these are the steps I have followed, assuming a
RAID1 array is md0:

# mdadm --grow /dev/md0 --bitmap=3Dnone
# mdadm --grow /dev/md0 --level=3D5 --raid-devices=3D3
- wait for reshape to complete
# mdadm --grow /dev/md0 --bitmap=3Dinternal

I noticed there is a difference between one array and another:

md125 : active raid5 sdb1[0] sda1[2] sdc1[1]
      1023976 blocks super 1.0 level 5, 4k chunk, algorithm 2 [3/3] [UU=
U]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md126 : active raid5 sdb2[0] sda2[2] sdc2[1]
      102397816 blocks super 1.1 level 5, 4k chunk, algorithm 2 [3/3] [=
UUU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

Is that a reference to the superblock? Why would they be different?
They were both created at the same time with the same fedora15
versions. This is created at the time the filesystem is created,
correct?

It looks like this has also now affected grub, as the system no longer
boots. Is this expected?

When I try to reinstall grub, it fails with an error relating to /boot:

# grub-install --recheck --root-directory=3D/mnt/disk /dev/sda
Probing devices to guess BIOS drives. This may take a long time.
/dev/md125 does not have any corresponding BIOS drive.

Maybe /boot should be left as RAID1?

Thanks,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
