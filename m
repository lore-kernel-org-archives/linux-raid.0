From: Matt Thrailkill <xwred1@modestolan.com>
Subject: mkraid, busted raid0 superblock
Date: Sat, 14 Feb 2004 19:59:29 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1076817569.7354.8.camel@tallgeese.xwredwing.net>
Reply-To: xwred1@modestolan.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Last night I triggered a bug in the driver for my ide controller, the
controller that the drives for my raid0 were hanging off of, and the
superblocks got out of sync.  After some googling and reading
(especially this:
http://marc.theaimsgroup.com/?l=linux-raid&m=107282085211211&w=2) it
looks like I should do an mkraid -R on my array.  My raidtab is the same
as when I created it, so I assume it is consistent.  

Only thing is, is there something I should examine with lsraid?  mkraid
mentions an lsraid howto which I can't find.  I did a few things with
lsraid, it reported the constituent drives of my array as being good. 
Whatever I do, I obviously want to keep the filesystem intact.  Any
tips?

Thanks.

