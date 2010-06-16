From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: RAID5: two disks dropping out
Date: Wed, 16 Jun 2010 21:32:05 +0200
Message-ID: <4C1926B5.3060106@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Greets, linux-raid-users,

at a customers/friends site we have a failing RAID5.

/dev/sda4 and /dev/sdc4 get kicked out of the raid5-array md3 over and
over again.

md3 consists of 6 partitions /dev/sd[a-f]4 and builds the only PV in a
LVM-based volume group, containing data.

md2 consists of 6 partitions /dev/sd[a-f]3 and is the root-fs.

I was able to boot via grml and re-add the kicked partitions and force
the activation of the arrays, I got the root-fs copied aside already.

Tomorrow I will be at place to see how to get the most important things
up and running again.

New hard-disks are ordered already.

I want to have RAID6 there in the end to get "n-2" fault tolerance.

Aside from having backups from a day ago:

What would you recommend me to do at first (without having the new
hard-disks in the morning)?

Boot via grml (or from the copied root-fs) and force the activation of
md3, then try to pull of the latest data out of the LVM-LVs ?

I want to get up the most important features up asap, imap-data is in
one LV ...

Currently I only have 2x250GB and 1x500GB SATA there, the new and
fitting 1xTB-drives will arrive there tomorrow afternoon.

Sorry, I can't provide any logs right now, the server is far away and
turned down right now.

If there are any clever tips on how to do that safe, or otoh to avoid
pitfalls, I would be happy to hear ...

Otherwise please excuse my potential faq ...

Thank you, Stefan
