From: <danfisher@bwkip.com>
Subject: Raid Boot problem
Date: Wed, 2 Apr 2003 18:28:32 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1763.204.250.25.205.1049326112.squirrel@webmail.bwkip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have 2 drives on redhat 7.0 with partitions of: No md0 for some reason in
my 7.0 raid

/root  md1
/var  md2
swap  md3
/boot  md4

Hda boots fine.
Hdb doesn't have the boot map written  - never faced this problem before

So I type Lilo to add the boot map to both drives and it only says hda is
available.  I need a second drive in the raid to preform an upgrade to get
7.0 outta the picture due to no further support.

-Dan


