From: Seth Hall <seth@speech.mit.edu>
Subject: Promise SX6000 question.
Date: Thu, 19 Dec 2002 12:02:49 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E01FBB9.1410FAB6@speech.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: linuxcomments@promise.com, Jordan Rhody <jordanr@promise.com>, support@promise.nl, support@promise.com.tw
List-Id: linux-raid.ids

Hi,

I am using a Promise SX6000 RAID controller and five Seagate 120GB drives to
create a 480GB RAID-5 array, to be used under Slackware v8.1. I was able to
compile and load the Promise pti_st.o module, and subsequently was able to
create a single new large partition on the /dev/sda1 drive, as follows:

Disk /dev/sda1: 64 heads, 32 sectors, 457758 cylinders
Units = cylinders of 2048 * 512 bytes

     Device Boot    Start       End    Blocks   Id  System
/dev/sda1p1             1    457758 468744176   83  Linux


The problem is I cannot seem to create a file system on this new partition. I
was assuming that ext3 would be a good initial  choice, at least while we were
fooling around using this new array.

Any thoughts about what I might be doing wrong, or what I might be missing?

	Thanks,
		Seth Hall
		Speech Comm. Group
		MIT, Cambridge
