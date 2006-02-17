From: Antti Salmela <asalmela@iki.fi>
Subject: Problem with growing raid1 array (2.6.16-rc1-git2)
Date: Fri, 17 Feb 2006 12:10:48 +0200
Message-ID: <20060217101048.GA11239@asalmela.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had two 80 GB disks in a raid1 set and wanted to replace them with new
300 GB disks. Replacing went fine and 'mdadm --grow --size max' seemed to
work fine until I tried to run 'pvresize'. pvresize complained that
md device was smaller than before and refused to resize and soon after
that there was also complaints about access beyond end of device.

After restarting md array everything worked fine and I was able to
resize physical volume successfully.

mdadm --version if that matters:
mdadm - v1.12.0 - 14 June 2005

Feb 16 19:40:23 galileo kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Feb 16 19:40:23 galileo kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Feb 16 19:40:23 galileo kernel: md: using 128k window, over a total of
80043136 blocks.
Feb 16 20:30:40 galileo kernel: md: md3: sync done.
Feb 16 20:30:40 galileo kernel: RAID1 conf printout:
Feb 16 20:30:40 galileo kernel:  --- wd:2 rd:2
Feb 16 20:30:40 galileo kernel:  disk 0, wo:0, o:1, dev:hdf1
Feb 16 20:30:40 galileo kernel:  disk 1, wo:0, o:1, dev:hdh1
Feb 16 22:45:52 galileo kernel: md: syncing RAID array md3
Feb 16 22:45:52 galileo kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Feb 16 22:45:52 galileo kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconst
ruction.
Feb 16 22:45:52 galileo kernel: md: using 128k window, over a total of
293049600 blocks.
Feb 16 22:45:52 galileo kernel: md: resuming recovery of md3 from
checkpoint.
Feb 16 22:45:54 galileo kernel: attempt to access beyond end of device
Feb 16 22:45:54 galileo kernel: md3: rw=1, want=23855496, limit=7285248
Feb 16 22:45:54 galileo kernel: Buffer I/O error on device dm-6, logical
block 0
Feb 16 22:45:54 galileo kernel: lost page write due to I/O error on dm-6

-- 
Antti Salmela
