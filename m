From: Caspar Smit <c.smit@truebit.nl>
Subject: Confusion about chunk/stripe size mdadm in combination with LVM
 stripe size
Date: Thu, 23 Aug 2012 11:04:37 +0200
Message-ID: <CAKFseUN74s+BOMmSvCFCpdohdfv8_JK7WMqEtcwsKtL9CTgJ3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I got a little confused about the various chunk/stripe sizes when
using mdadm in combination with LVM.
I searched the mailing list archives and googled it but couldn't
really find a definite answer to my question.

I'm searching for the most optimal chunk/stripe sizes using mdadm and LVM.


Here's an example setup:

I created 2 md sets, both raid10 containing 8 disks with a chunk size of 512Kb

This is where the confusion starts and correct me if i'm wrong here:
To my knowledge I now have a stripe size of 2048Kb on each md set
raid10 has 4 actual data disks (and 4 mirrors), so one stripe of data
is 4x 512Kb = 2048Kb


Now when using LVM:

I created two PV's of both md sets and added them to one VG.
Now when I create a LV and like to stripe across both PV's (md sets)
what would be the ideal stripe size?

2048Kb or 4096Kb?

When i read the LVM documentation about creating a striped LV, it
looks like the stripe size is what mdadm calls the chunk size.
Or is the stripe size the size of a total stripe across all PV's?

I hope someone can clarify this for me.

P.S. I'm also curious how this calculation would be if using different
raid levels like raid5 or raid6

Kind regards,
Caspar Smit
