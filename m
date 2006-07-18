From: Janos Farkas <chexum+dev@gmail.com>
Subject: Re: mdadm -X bitmap status off by 2^16
Date: Tue, 18 Jul 2006 18:54:51 +0200
Message-ID: <priv$8d118c145629$9b94d13755@200607.shadow.banki.hu>
References: <priv$efbe06145625$36d67b3763@200607.gmail.com> <44BCFEA2.20301@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44BCFEA2.20301@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

On 2006-07-18 at 11:30:42, Paul Clements wrote:
> >Personalities : [raid1] [raid6] [raid5] [raid4]
> >md0 : active raid5 hdd3[2] hdb3[0] hda3[1]
> >      585569024 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> >      bitmap: 0/140 pages [0KB], 1024KB chunk
> This indicates that the _in-memory_ bits are all cleared.

Makes sense.

> At array startup, md initializes the in-memory bitmap from the on-disk 
> copy. It then uses the in-memory bitmap from that point on, shadowing 
> any changes there into the on-disk bitmap.
> 
> At the end of a rebuild (which should have happened after you added the 
> third disk), the bits should all be cleared. The on-disk bits get 
> cleared lazily, though. Is there any chance that they are cleared now? 
> If not, it sounds like a bug to me.

I just removed/readded the bitmap as follows, but before that, the 65536
still was there as of 5 minutes ago.

# mdadm /dev/md0 --grow -b none
# for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
          Bitmap : 285923 bits (chunks), 3 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 3 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 65539 dirty (22.9%)
# for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
          Bitmap : 285923 bits (chunks), 3 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 3 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 65539 dirty (22.9%)

(Bitmaps still present, probably I was just too impatient after the
removal)

# mdadm /dev/md0 --grow -b internal
# for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
          Bitmap : 285923 bits (chunks), 285923 dirty (100.0%)
          Bitmap : 285923 bits (chunks), 285923 dirty (100.0%)
          Bitmap : 285923 bits (chunks), 285923 dirty (100.0%)
# for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
          Bitmap : 285923 bits (chunks), 285923 dirty (100.0%)
          Bitmap : 285923 bits (chunks), 285923 dirty (100.0%)
          Bitmap : 285923 bits (chunks), 285923 dirty (100.0%)
# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 hdd3[2] hdb3[0] hda3[1]
      585569024 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 140/140 pages [560KB], 1024KB chunk

unused devices: <none>

(Ouch, I hoped there wouldn't be another resync :)

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid5 hdd3[2] hdb3[0] hda3[1]
      585569024 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 1/140 pages [4KB], 1024KB chunk

unused devices: <none>

(Now the in-memory bitmaps seems to be emptied again)

# for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
          Bitmap : 285923 bits (chunks), 285923 dirty (100.0%)
          Bitmap : 285923 bits (chunks), 285923 dirty (100.0%)
          Bitmap : 285923 bits (chunks), 285923 dirty (100.0%)
# for i in hdb3 hdd3 hda3 ; mdadm -X /dev/$i|grep map
          Bitmap : 285923 bits (chunks), 0 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 0 dirty (0.0%)
          Bitmap : 285923 bits (chunks), 0 dirty (0.0%)

And fortunately the on disk ones too...

This discrepancy was there after at least two reboots after the whole
resync has been done.  I also did a "scrub" (check) on the array, and
it still did not change.
