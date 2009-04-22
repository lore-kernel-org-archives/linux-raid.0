From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Wed, 22 Apr 2009 20:45:53 +0200
Message-ID: <slrnguupf4.911.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
 <18922.50050.860008.242658@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:
> Could you let me know if that following patch helps?

Hmmm, it looks like the patch doesn't fully fix it.
I told you already about the semi-initialized on-disk bitmap:

root@darkside:~# mdadm -X /dev/sd[cdefgh][1] | grep Bitmap | sort
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)

I tried to clean it up with:
root@darkside:~# echo 0-268275 > /sys/block/md7/md/bitmap_set_bits

This should set all bits, and it seems to do:
root@darkside:~# mdadm -X /dev/sd[cdefgh][1] | grep Bitmap 
          Bitmap : 268275 bits (chunks), 268275 dirty (100.0%)
          Bitmap : 268275 bits (chunks), 268275 dirty (100.0%)
          Bitmap : 268275 bits (chunks), 268275 dirty (100.0%)
          Bitmap : 268275 bits (chunks), 268275 dirty (100.0%)
          Bitmap : 268275 bits (chunks), 268275 dirty (100.0%)
          Bitmap : 268275 bits (chunks), 268275 dirty (100.0%)

However, in-kernel it should also allocate all pages, but it does not:
root@darkside:~# head -4 /proc/mdstat 
Personalities : [raid1] [raid10] 
md7 : active (auto-read-only) raid10 sdc1[0] sdh1[5] sde1[4] sdg1[3] sdd1[2] sdf1[1]
      4395406848 blocks 512K chunks 2 near-copies [6/6] [UUUUUU]
      bitmap: 64/131 pages [256KB], 16384KB chunk

stopping/starting the array doesn't help either:
root@darkside:~# mdadm --stop /dev/md7
mdadm: stopped /dev/md7
root@darkside:~# mdadm -A /dev/md7
mdadm: /dev/md7 has been started with 6 drives.
root@darkside:~# head -4 /proc/mdstat 
Personalities : [raid1] [raid10] 
md7 : active (auto-read-only) raid10 sdc1[0] sdh1[5] sde1[4] sdg1[3] sdd1[2] sdf1[1]
      4395406848 blocks 512K chunks 2 near-copies [6/6] [UUUUUU]
      bitmap: 64/131 pages [256KB], 16384KB chunk
root@darkside:~# sleep 10
root@darkside:~# head -4 /proc/mdstat 
Personalities : [raid1] [raid10] 
md7 : active (auto-read-only) raid10 sdc1[0] sdh1[5] sde1[4] sdg1[3] sdd1[2] sdf1[1]
      4395406848 blocks 512K chunks 2 near-copies [6/6] [UUUUUU]
      bitmap: 0/131 pages [0KB], 16384KB chunk
root@darkside:~# echo 3 > /proc/sys/vm/drop_caches 
root@darkside:~# mdadm -X /dev/sd[cdefgh][1] | grep Bitmap
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)
          Bitmap : 268275 bits (chunks), 137203 dirty (51.1%)


regards
   Mario
-- 
As a rule, the more bizarre a thing is, the less mysterious it proves to be.
                                    -- Sherlock Holmes by Arthur Conan Doyle

