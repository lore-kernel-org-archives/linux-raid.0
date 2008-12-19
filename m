From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: weird issues with raid1
Date: Fri, 19 Dec 2008 14:40:46 -0600
Message-ID: <cccedfc60812191240m185d5f49td1ec2070c70c88e4@mail.gmail.com>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	 <18759.678.74091.236787@notabene.brown>
	 <18761.54425.725696.255055@notabene.brown>
	 <cccedfc60812172050h58697665y975a18550842aebb@mail.gmail.com>
	 <cccedfc60812172055n58181ad4lcdff8f172c6a496c@mail.gmail.com>
	 <18761.56537.935250.561921@notabene.brown>
	 <cccedfc60812172147q240466a8w53c5bd2540edf6a4@mail.gmail.com>
	 <18761.60380.938542.26851@notabene.brown>
	 <cccedfc60812181815oa63b526tb51c3bee558fbdf@mail.gmail.com>
	 <cccedfc60812190851x446a6046p2578b8de72edc93b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60812190851x446a6046p2578b8de72edc93b@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 19, 2008 at 10:51 AM, Jon Nelson
<jnelson-linux-raid@jamponi.net> wrote:
>> I'll apply and get back to you. My raid rebuilt 3 times today, quite
>> possibly because of this.
>
> I'm now running the patch from
> a0da84f35b25875870270d16b6eccda4884d61a7 and it still did a complete
> rebuild. Was that expected, the first time the device was re-added?

After the array reconstructed completely, I did the following:

1. --fail then --remove /dev/nbd0
2. unmounted /dev/md11
3. mdadm --stop /dev/md11
4. mdadm --assemble --scan (this started /dev/md11):

Dec 19 14:21:17 turnip kernel: raid1: raid set md11 active with 1 out
of 2 mirrors
Dec 19 14:21:17 turnip kernel: md11: bitmap initialized from disk:
read 1/1 pages, set 0 bits
Dec 19 14:21:17 turnip kernel: created bitmap (10 pages) for device md11

5. fsck.ext3 -f -v -D -C0 /dev/md11 (this caused some writes to take
place, and I wanted to fsck the volume anyway)

6. --re-add /dev/nbd0

At step 6, the array decided to go into recovery:

Dec 19 14:32:26 turnip kernel: md: bind<nbd0>
Dec 19 14:32:26 turnip kernel: RAID1 conf printout:
Dec 19 14:32:26 turnip kernel:  --- wd:1 rd:2
Dec 19 14:32:26 turnip kernel:  disk 0, wo:1, o:1, dev:nbd0
Dec 19 14:32:26 turnip kernel:  disk 1, wo:0, o:1, dev:sda
Dec 19 14:32:26 turnip kernel: md: recovery of RAID array md11

and has some time to go ...

      [=>...................]  recovery =  7.7% (6031360/78123988)
finish=234.6min speed=5120K/sec

At the time I --re-add'd /dev/nbd0, I also did an --examine and
--examine-bitmap of /dev/nbd0:

Dec 19 14:32:26 turnip nbd0-frank: /dev/nbd0:
Dec 19 14:32:26 turnip nbd0-frank:           Magic : a92b4efc
Dec 19 14:32:26 turnip nbd0-frank:         Version : 1.0
Dec 19 14:32:26 turnip nbd0-frank:     Feature Map : 0x1
Dec 19 14:32:26 turnip nbd0-frank:      Array UUID :
cf24d099:9e174a79:2a2f6797:dcff1420
Dec 19 14:32:26 turnip nbd0-frank:            Name : turnip:11  (local
to host turnip)
Dec 19 14:32:26 turnip nbd0-frank:   Creation Time : Mon Dec 15 07:06:13 2008
Dec 19 14:32:26 turnip nbd0-frank:      Raid Level : raid1
Dec 19 14:32:26 turnip nbd0-frank:    Raid Devices : 2
Dec 19 14:32:26 turnip nbd0-frank:
Dec 19 14:32:26 turnip nbd0-frank:  Avail Dev Size : 160086384 (76.34
GiB 81.96 GB)
Dec 19 14:32:26 turnip nbd0-frank:      Array Size : 156247976 (74.50
GiB 80.00 GB)
Dec 19 14:32:26 turnip nbd0-frank:   Used Dev Size : 156247976 (74.50
GiB 80.00 GB)
Dec 19 14:32:26 turnip nbd0-frank:    Super Offset : 160086512 sectors
Dec 19 14:32:26 turnip nbd0-frank:           State : clean
Dec 19 14:32:26 turnip nbd0-frank:     Device UUID :
01524a75:c309869c:6da972c9:084115c6
Dec 19 14:32:26 turnip nbd0-frank:
Dec 19 14:32:26 turnip nbd0-frank: Internal Bitmap : 2 sectors from superblock
Dec 19 14:32:26 turnip nbd0-frank:       Flags : write-mostly
Dec 19 14:32:26 turnip nbd0-frank:     Update Time : Fri Dec 19 14:20:52 2008
Dec 19 14:32:26 turnip nbd0-frank:        Checksum : 63bef0c2 - correct
Dec 19 14:32:26 turnip nbd0-frank:          Events : 5388
Dec 19 14:32:26 turnip nbd0-frank:
Dec 19 14:32:26 turnip nbd0-frank:
Dec 19 14:32:26 turnip nbd0-frank:     Array Slot : 2 (failed, failed, 0, 1)
Dec 19 14:32:26 turnip nbd0-frank:    Array State : Uu 2 failed
Dec 19 14:32:26 turnip nbd0-frank:         Filename : /dev/nbd0
Dec 19 14:32:26 turnip nbd0-frank:            Magic : 6d746962
Dec 19 14:32:26 turnip nbd0-frank:          Version : 4
Dec 19 14:32:26 turnip nbd0-frank:             UUID :
cf24d099:9e174a79:2a2f6797:dcff1420
Dec 19 14:32:26 turnip nbd0-frank:           Events : 5388
Dec 19 14:32:26 turnip nbd0-frank:   Events Cleared : 4462
Dec 19 14:32:26 turnip nbd0-frank:            State : OK
Dec 19 14:32:26 turnip nbd0-frank:        Chunksize : 4 MB
Dec 19 14:32:26 turnip nbd0-frank:           Daemon : 5s flush period
Dec 19 14:32:26 turnip nbd0-frank:       Write Mode : Allow write
behind, max 256
Dec 19 14:32:26 turnip nbd0-frank:        Sync Size : 78123988 (74.50
GiB 80.00 GB)
Dec 19 14:32:26 turnip nbd0-frank:           Bitmap : 19074 bits
(chunks), 0 dirty (0.0%)
Dec 19 14:32:26 turnip nbd0-frank: Pre-setting the recovery speed to
5MB/s to avoid saturating netwo
rk...
Dec 19 14:32:26 turnip nbd0-frank: Adding /dev/nbd0 to /dev/md11....
Dec 19 14:32:26 turnip kernel: md: bind<nbd0>



So. What's going on here? I applied the patch which /starts out/
looking like this:


diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index b26927c..dedba16 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -454,8 +454,11 @@ void bitmap_update_sb(struct bitmap *bitmap)
        spin_unlock_irqrestore(&bitmap->lock, flags);
        sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
        sb->events = cpu_to_le64(bitmap->mddev->events);
-       if (!bitmap->mddev->degraded)
-               sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
+       if (bitmap->mddev->events < bitmap->events_cleared) {
+               /* rocking back to read-only */
+               bitmap->events_cleared = bitmap->mddev->events;
+               sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
+       }
        kunmap_atomic(sb, KM_USER0);
        write_page(bitmap, bitmap->sb_page, 1);
 }
@@ -1085,9 +1088,19 @@ void bitmap_daemon_work(struct bitmap *bitmap)


To the 2.6.25.18-0.2 source, rebuilt, installed, and rebooted.

/me wipes brow

-- 
Jon
