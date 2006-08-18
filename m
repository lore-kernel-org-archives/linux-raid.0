From: raid@bymeinc.com
Subject: Re: [bug?] raid1 integrity checking is broken on 2.6.18-rc4
Date: Fri, 18 Aug 2006 12:38:58 -0400 (EDT)
Message-ID: <20060818163858.0ABA5AE344@bymeinc.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil introduced read-checking into 2.6.16. In versions prior, mirror copies were overwritten instead of checked.

I'm running 2.6.17rc4:
# echo "check" > /sys/block/md0/md/sync_action
# dmesg
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 15542784 blocks.

# dstat -d -D sda,sdg
--disk/sda----disk/sdg-
_read write:_read write
  81k   30k:  81k   30k
  58M    0 :  58M    0
  58M    0 :  57M    0
  57M    0 :  58M    0
  58M    0 :  57M    0

Although the message uses the word "reconscruction," the drives are being checked for consistancy.



-----------------
I just tried the patch and now it seems to be syncing the drives instead
of only checking them?  (At the very least the message is misleading.)

 # echo "check" >/sys/block/md0/md/sync_action
 # dmesg | tail -9
 md: syncing RAID array md0
 md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
 md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
 md: using 128k window, over a total of 104256 blocks.
 md: md0: sync done.
 RAID1 conf printout:
  --- wd:2 rd:2
  disk 0, wo:0, o:1, dev:hda9
  disk 1, wo:0, o:1, dev:sda5
