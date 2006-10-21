From: Chase Venters <chase.venters@clientec.com>
Subject: Bug with RAID1 hot spares?
Date: Fri, 20 Oct 2006 20:46:19 -0500
Message-ID: <200610202046.43033.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jason.meinzer@gmail.com
List-Id: linux-raid.ids

Greetings,
	I was just testing a server I was about to send into production on kernel 
2.6.18.1. The server has three SCSI disks with "md1" set to a RAID1 with 2 
mirrors and 1 spare. The mirrors are sda3 and sdb3, spare is sdc3. I manually 
failed sdb3, and as expected, sdc3 was activated. Strangely 
enough, /proc/mdstat did not indicate that sdc3 was being synced. I thought 
these spares weren't kept mirrored until needed?
	In order to further test my theory, I manually failed sda3, leaving only sdc3 
(the original spare) active. I ran "find /" for a bit to see if any errors 
cropped up and none did; however, when I added sda3 and sdb3 back to the 
array and a resync started, I was soon faced with what appeared to be a 
_very_ corrupted reiserfs.
	Strangely enough, after booting on a livecd and assembling md1 with just 
sda3, I was able to add sdb3 and sdc3, after which the array resynced and 
left sdb3 a mirror and sdc3 a spare.
	So there's definitely something odd happening here... why did no resync to 
the sdc3 spare start when I failed sdb3?

Thanks,
Chase
