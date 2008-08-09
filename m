From: tiberios@tiberios.force9.co.uk
Subject: active(auto-read-only)
Date: Sat, 9 Aug 2008 15:38:16 +0100 (BST)
Message-ID: <15265.80.192.81.201.1218292696.squirrel@webmail.plus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm currently having issues with a raid array being marked as
active(auto-read-only).  It's a raid 5 array of 4 disks plus a 1 hot
spare.  I was attempting to grow it to use all 5 disks when my server
hung, just after it backed up the critical sector information.  Now, I've
seen people on this list being told do  mdadm /dev/md0 --readwrite. 
Unfortunately this just causes my machine to hang again.

Does anyone have any suggestions?

Regards,

Ewan.

