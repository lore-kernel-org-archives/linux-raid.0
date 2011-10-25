From: linbloke <linbloke@fastmail.fm>
Subject: Re: Rotating RAID 1
Date: Tue, 25 Oct 2011 18:34:57 +1100
Message-ID: <4EA666A1.9000904@fastmail.fm>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com> <4E497FB5.3030109@ivitera.com> <CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com> <4E49849E.4030604@ivitera.com> <20110816084251.2d8e7831@notabene.brown> <CALJXSJqVD9ibB9LAM7jU5aJFbyEssCuf2QMai+K=8xk6=pfRew@mail.gmail.com> <20110816095517.757afc07@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110816095517.757afc07@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>, Pavel Hofman <pavel.hofman@ivitera.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/08/11 9:55 AM, NeilBrown wrote:
> On Mon, 15 Aug 2011 19:32:04 -0400 J=E9r=F4me Poulin<jeromepoulin@gma=
il.com>
> wrote:
>
>> On Mon, Aug 15, 2011 at 6:42 PM, NeilBrown<neilb@suse.de>  wrote:
>>> So if there are 3 drives A, X, Y where A is permanent and X and Y a=
re rotated
>>> off-site, then I create two RAID1s like this:
>>>
>>>
>>> mdadm -C /dev/md0 -l1 -n2 --bitmap=3Dinternal /dev/A /dev/X
>>> mdadm -C /dev/md1 -l1 -n2 --bitmap=3Dinternal /dev/md0 /dev/Y
>> That seems nice for 2 disks, but adding another one later would be a
>> mess. Is there any way to play with slots number manually to make it
>> appear as an always degraded RAID ? I can't plug all the disks at on=
ce
>> because of the maximum of 2 ports.
> Yes, add another one later would be difficult.  But if you know up-fr=
ont that
> you will want three off-site devices it is easy.
>
> You could
>
>   mdadm -C /dev/md0 -l1 -n2 -b internal /dev/A missing
>   mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 missing
>   mdadm -C /dev/md2 -l1 -n2 -b internal /dev/md1 missing
>   mdadm -C /dev/md3 -l1 -n2 -b internal /dev/md2 missing
>
>   mkfs /dev/md3 ; mount ..
>
>   So you now have 4 "missing" devices.  Each time you plug in a devic=
e that
>   hasn't been in an array before, explicitly add it to the array that=
 you want
>   it to be a part of and let it recover.
>   When you plug in a device that was previously plugged in, just "mda=
dm
>   -I /dev/XX" and it will automatically be added and recover based on=
 the
>   bitmap.
>
>   You can have as many or as few of the transient drives plugged in a=
t any
>   time as you like.
>
>   There is a cost here of course.  Every write potentially needs to u=
pdate
>   every bitmap, so the more bitmaps, the more overhead in updating th=
em.  So
>   don't create more than you need.
>
>   Also, it doesn't have to be a linear stack.  It could be a binary t=
ree
>   though that might take a little more care to construct.  Then when =
an
>   adjacent pair of leafs are both off-site, their bitmap would not ne=
ed
>   updating.
>
> NeilBrown

Hi Neil, J=E9r=F4me and Pavel,

I'm in the process of testing the solution described above and have bee=
n=20
successful at those steps (I now have sync'd devices that I have failed=
=20
and removed from their respective arrays - the "backups"). I can add ne=
w=20
devices and also incrementally re-add the devices back to their=20
respective arrays and all my tests show this process works well. The=20
point which I'm now trying to resolve is how to create a new array from=
=20
one of the off-site components - ie, the restore from backup test.
Below are the steps I've taken to implement and verify each step, you=20
can skip to the bottom section "Restore from off-site backup" to get to=
=20
the point if you like. When the wiki is back up, I'll post this process=
=20
there for others who are looking for mdadm based offline backups. Any=20
corrections gratefully appreciated.

Based on the example above, for a target setup of 7 off-site devices=20
synced to a two device RAID1, my test setup for a is:

RAID Array    Online Device    Off-site device
md100    sdc         sdd
md101    md100    sde
md102    md101    sdf
md103    md102    sdg
md104    md103    sdh
md105    md104    sdi
md106    md105    sdj

root@deb6dev:~# uname -a
Linux deb6dev 2.6.32-5-686 #1 SMP Tue Mar 8 21:36:00 UTC 2011 i686 GNU/=
Linux
root@deb6dev:~# mdadm -V
mdadm - v3.1.4 - 31st August 2010
root@deb6dev:~# cat /etc/debian_version
6.0.1

Create the nested arrays
---------------------
root@deb6dev:~# mdadm -C /dev/md100 -l1 -n2 -b internal -e 1.2 /dev/sdc=
=20
missing
mdadm: array /dev/md100 started.
root@deb6dev:~# mdadm -C /dev/md101 -l1 -n2 -b internal -e 1.2=20
/dev/md100 missing
mdadm: array /dev/md101 started.
root@deb6dev:~# mdadm -C /dev/md102 -l1 -n2 -b internal -e 1.2=20
/dev/md101 missing
mdadm: array /dev/md102 started.
root@deb6dev:~# mdadm -C /dev/md103 -l1 -n2 -b internal -e 1.2=20
/dev/md102 missing
mdadm: array /dev/md103 started.
root@deb6dev:~# mdadm -C /dev/md104 -l1 -n2 -b internal -e 1.2=20
/dev/md103 missing
mdadm: array /dev/md104 started.
root@deb6dev:~# mdadm -C /dev/md105 -l1 -n2 -b internal -e 1.2=20
/dev/md104 missing
mdadm: array /dev/md105 started.
root@deb6dev:~# mdadm -C /dev/md106 -l1 -n2 -b internal -e 1.2=20
/dev/md105 missing
mdadm: array /dev/md106 started.

root@deb6dev:~# cat /proc/mdstat
Personalities : [raid1]
md106 : active (auto-read-only) raid1 md105[0]
       51116 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md105 : active raid1 md104[0]
       51128 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md104 : active raid1 md103[0]
       51140 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md103 : active raid1 md102[0]
       51152 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md102 : active raid1 md101[0]
       51164 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md101 : active raid1 md100[0]
       51176 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md100 : active raid1 sdc[0]
       51188 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>

Create and mount a filesystem
--------------------------
root@deb6dev:~# mkfs.ext3 /dev/md106
<<successful mkfs output snipped>>
root@deb6dev:~# mount -t ext3 /dev/md106 /mnt/backup
root@deb6dev:~# df | grep backup
/dev/md106               49490      4923     42012  11% /mnt/backup

Plug in a device that hasn't been in an array before
-------------------------------------------
root@deb6dev:~# mdadm -vv /dev/md100 --add /dev/sdd
mdadm: added /dev/sdd
root@deb6dev:~# cat /proc/mdstat
Personalities : [raid1]
md106 : active raid1 md105[0]
       51116 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md105 : active raid1 md104[0]
       51128 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md104 : active raid1 md103[0]
       51140 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md103 : active raid1 md102[0]
       51152 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md102 : active raid1 md101[0]
       51164 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md101 : active raid1 md100[0]
       51176 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

md100 : active raid1 sdd[2] sdc[0]
       51188 blocks super 1.2 [2/2] [UU]
       bitmap: 1/1 pages [4KB], 65536KB chunk


Write to the array
---------------
root@deb6dev:~# dd if=3D/dev/urandom of=3Da.blob bs=3D1M count=3D20
20+0 records in
20+0 records out
20971520 bytes (21 MB) copied, 5.05528 s, 4.1 MB/s
root@deb6dev:~# dd if=3D/dev/urandom of=3Db.blob bs=3D1M count=3D10
10+0 records in
10+0 records out
10485760 bytes (10 MB) copied, 2.59361 s, 4.0 MB/s
root@deb6dev:~# dd if=3D/dev/urandom of=3Dc.blob bs=3D1M count=3D5
5+0 records in
5+0 records out
5242880 bytes (5.2 MB) copied, 1.35619 s, 3.9 MB/s
root@deb6dev:~# md5sum *blob > md5sums.txt
root@deb6dev:~# ls -l
total 35844
-rw-r--r-- 1 root root 20971520 Oct 25 15:57 a.blob
-rw-r--r-- 1 root root 10485760 Oct 25 15:57 b.blob
-rw-r--r-- 1 root root  5242880 Oct 25 15:57 c.blob
-rw-r--r-- 1 root root      123 Oct 25 15:57 md5sums.txt
root@deb6dev:~# cp *blob /mnt/backup
root@deb6dev:~# ls -l /mnt/backup
total 35995
-rw-r--r-- 1 root root 20971520 Oct 25 15:58 a.blob
-rw-r--r-- 1 root root 10485760 Oct 25 15:58 b.blob
-rw-r--r-- 1 root root  5242880 Oct 25 15:58 c.blob
drwx------ 2 root root    12288 Oct 25 15:27 lost+found
root@deb6dev:~# df | grep backup
/dev/md106               49490     40906      6029  88% /mnt/backup
root@deb6dev:~# cat /proc/mdstat | grep -A 3 '^md100'
md100 : active raid1 sdd[2] sdc[0]
       51188 blocks super 1.2 [2/2] [UU]
       bitmap: 0/1 pages [0KB], 65536KB chunk

Data written and array devices in sync (bitmap 0/1)

=46ail and remove device
-------------------
root@deb6dev:~# sync
root@deb6dev:~# mdadm -vv /dev/md100 --fail /dev/sdd --remove /dev/sdd
mdadm: set /dev/sdd faulty in /dev/md100
mdadm: hot removed /dev/sdd from /dev/md100
root@deb6dev:~# cat /proc/mdstat | grep -A 3 '^md100'
md100 : active raid1 sdc[0]
       51188 blocks super 1.2 [2/1] [U_]
       bitmap: 0/1 pages [0KB], 65536KB chunk

Device may now be unplugged


Write to the array again
--------------------
root@deb6dev:~# rm /mnt/backup/b.blob
root@deb6dev:~# ls -l /mnt/backup
total 25714
-rw-r--r-- 1 root root 20971520 Oct 25 15:58 a.blob
-rw-r--r-- 1 root root  5242880 Oct 25 15:58 c.blob
drwx------ 2 root root    12288 Oct 25 15:27 lost+found
root@deb6dev:~# df | grep backup
/dev/md106               49490     30625     16310  66% /mnt/backup
root@deb6dev:~# cat /proc/mdstat | grep -A 3 '^md100'
md100 : active raid1 sdc[0]
       51188 blocks super 1.2 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

bitmap 1/1 shows array is not in sync (we know it's due to the writes=20
pending for the device we previously failed)

Plug in a device that was previously plugged in
----------------------------------------
root@deb6dev:~# mdadm -vv -I /dev/sdd --run
mdadm: UUID differs from /dev/md/0.
mdadm: UUID differs from /dev/md/1.
mdadm: /dev/sdd attached to /dev/md100 which is already active.
root@deb6dev:~# sync
root@deb6dev:~# cat /proc/mdstat | grep -A 3 '^md100'
md100 : active raid1 sdd[2] sdc[0]
       51188 blocks super 1.2 [2/2] [UU]
       bitmap: 0/1 pages [0KB], 65536KB chunk

Device reconnected [UU] and in sync (bitmap 0/1)

Restore from off-site device
------------------------
Remove device from array
root@deb6dev:~# mdadm -vv /dev/md100 --fail /dev/sdd --remove /dev/sdd
mdadm: set /dev/sdd faulty in /dev/md100
mdadm: hot removed /dev/sdd from /dev/md100
root@deb6dev:~# mdadm -Ev /dev/sdd
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 4c957fac:d7dbc792:b642daf0:d22e313e
            Name : deb6dev:100  (local to host deb6dev)
   Creation Time : Tue Oct 25 15:22:19 2011
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 102376 (50.00 MiB 52.42 MB)
      Array Size : 102376 (50.00 MiB 52.42 MB)
     Data Offset : 24 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 381f453f:5a97f1f6:bb5098bb:8c071a95

Internal Bitmap : 8 sectors from superblock
     Update Time : Tue Oct 25 17:27:53 2011
        Checksum : acbcee5f - correct
          Events : 250


    Device Role : Active device 1
    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)

Assemble a new array from off-site component:
root@deb6dev:~# mdadm -vv -A /dev/md200 --run /dev/sdd
mdadm: looking for devices for /dev/md200
mdadm: /dev/sdd is identified as a member of /dev/md200, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md200
mdadm: added /dev/sdd to /dev/md200 as 1
mdadm: /dev/md200 has been started with 1 drive (out of 2).
root@deb6dev:~#

Check file-system on new array
root@deb6dev:~# fsck.ext3 -f -n /dev/md200
e2fsck 1.41.12 (17-May-2010)
fsck.ext3: Superblock invalid, trying backup blocks...
fsck.ext3: Bad magic number in super-block while trying to open /dev/md=
200

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblo=
ck:
     e2fsck -b 8193 <device>


How do I use these devices in a new array?

Kind regards and thanks for your help,
Josh

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
