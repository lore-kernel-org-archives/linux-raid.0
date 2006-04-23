From: "Ewan Grantham" <ewan.grantham@gmail.com>
Subject: EVMS causing problems with mdadm?
Date: Sun, 23 Apr 2006 10:33:25 -0500
Message-ID: <6d5bedd80604230833m3614f453we869b8bf7261d0e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Did my latest updates for my Kubuntu (Ubuntu KDE variant) this
morning, and noticed that EVMS has now "taken control" of my RAID
array. Didn't think much about it until I tried to make a RAID-1 array
with two disks I've just added to the system. Trying to do a create
verbose tells me that device /dev/md1 (or 2 or 3 - I tried a couple
just to see) doesn't exist. And in fact, there are no block devices
listed beyond md0.

Trying to go into EVMS to create a new Volume brings up the screen for
doing so, but doesn't actually let you create a new one.

Any suggestion of what I might be doing wrong, or is this a bug I
should be reporting to the Ubuntu folks?
