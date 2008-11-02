From: "George Spelvin" <linux@horizon.com>
Subject: Re: mdraid10 regression in 2.6.27.4 (possibly earlier)
Date: Sun, 02 Nov 2008 12:33:46 -0500
Message-ID: <20081102173346.1685.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com
List-Id: linux-raid.ids

I'd just like to note that I have the same problem with 2.6.27.
/proc/mdstat is stuck saying
      
md4 : active raid10 sde3[6](S) sdf3[4] sdd3[2] sdc3[1] sdb3[0] sda3[5]
      131837184 blocks 256K chunks 2 near-copies [6/5] [UUU_UU]
      bitmap: 31/126 pages [124KB], 512KB chunk

while the kernel complains every second or so:
Nov  2 17:28:32: RAID10 conf printout:
Nov  2 17:28:32:  --- wd:5 rd:6
Nov  2 17:28:32:  disk 0, wo:0, o:1, dev:sdb3
Nov  2 17:28:32:  disk 1, wo:0, o:1, dev:sdc3
Nov  2 17:28:32:  disk 2, wo:0, o:1, dev:sdd3
Nov  2 17:28:32:  disk 4, wo:0, o:1, dev:sdf3
Nov  2 17:28:32:  disk 5, wo:0, o:1, dev:sda3
Nov  2 17:28:33: RAID10 conf printout:
Nov  2 17:28:33:  --- wd:5 rd:6
Nov  2 17:28:33:  disk 0, wo:0, o:1, dev:sdb3
Nov  2 17:28:33:  disk 1, wo:0, o:1, dev:sdc3
Nov  2 17:28:33:  disk 2, wo:0, o:1, dev:sdd3
Nov  2 17:28:33:  disk 4, wo:0, o:1, dev:sdf3
Nov  2 17:28:33:  disk 5, wo:0, o:1, dev:sda3
Nov  2 17:28:38: RAID10 conf printout:
Nov  2 17:28:38:  --- wd:5 rd:6
Nov  2 17:28:38:  disk 0, wo:0, o:1, dev:sdb3
Nov  2 17:28:38:  disk 1, wo:0, o:1, dev:sdc3
Nov  2 17:28:38:  disk 2, wo:0, o:1, dev:sdd3
Nov  2 17:28:38:  disk 4, wo:0, o:1, dev:sdf3
Nov  2 17:28:38:  disk 5, wo:0, o:1, dev:sda3
Nov  2 17:28:38: RAID10 conf printout:
Nov  2 17:28:38:  --- wd:5 rd:6
Nov  2 17:28:38:  disk 0, wo:0, o:1, dev:sdb3
Nov  2 17:28:38:  disk 1, wo:0, o:1, dev:sdc3
Nov  2 17:28:38:  disk 2, wo:0, o:1, dev:sdd3
Nov  2 17:28:38:  disk 4, wo:0, o:1, dev:sdf3
Nov  2 17:28:38:  disk 5, wo:0, o:1, dev:sda3
Nov  2 17:28:43: RAID10 conf printout:
Nov  2 17:28:43:  --- wd:5 rd:6
Nov  2 17:28:43:  disk 0, wo:0, o:1, dev:sdb3
Nov  2 17:28:43:  disk 1, wo:0, o:1, dev:sdc3
Nov  2 17:28:43:  disk 2, wo:0, o:1, dev:sdd3
Nov  2 17:28:43:  disk 4, wo:0, o:1, dev:sdf3
Nov  2 17:28:43:  disk 5, wo:0, o:1, dev:sda3
Nov  2 17:28:44: RAID10 conf printout:
Nov  2 17:28:44:  --- wd:5 rd:6
Nov  2 17:28:44:  disk 0, wo:0, o:1, dev:sdb3
Nov  2 17:28:44:  disk 1, wo:0, o:1, dev:sdc3
Nov  2 17:28:44:  disk 2, wo:0, o:1, dev:sdd3
Nov  2 17:28:44:  disk 4, wo:0, o:1, dev:sdf3
Nov  2 17:28:44:  disk 5, wo:0, o:1, dev:sda3

This is Not Good (tm).

Quad-core Phenom, 64-bit kernel and userland.
