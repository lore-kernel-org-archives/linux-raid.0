From: whollygoat@letterboxes.org
Subject: some ?? re failed disk and resyncing of array
Date: Sat, 31 Jan 2009 00:16:56 -0800
Message-ID: <1233389816.28363.1297740563@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On a boot a couple of days ago, mdadm failed a disk and
started resyncing to spare (raid5, 6 drives, 5 active, 1
spare).  smartctl -H <disk> returned info (can't remember
the exact text) that made me suspect the drive was
fine, but the data connection was bad.  Sure enough the
data cable was damaged.  Replaced the cable and smartctl
sees the disk just fine and reports no errors.

- I'd like to readd the drive as a spare.  Is it enough
to "mdadm --add /dev/hdk" or do I need to prep the drive to
remove any data that said where it previously belonged
in the array?  

- When I tried to list some files on one of the filesystems
on the array (the fact that it took so long to react to
the ls is how I discovered the box was in the middle of
rebuiling to spare) it couldn't find the file (or many 
others).  I thought that resyncing was supposed to be
transparent, yet parts of the fs seemed to be missing.
Everything was there afterwards.  Is that normal?

- On a subsequent boot I had to run e2fsck on the three
filesystems housed on the array.  Many stray blocks, 
illegal inodes, etc were found.  An artifact of the rebuild
or unrelated?

Thanks.

WG
-- 
  
  whollygoat@letterboxes.org

-- 
http://www.fastmail.fm - Send your email first class

