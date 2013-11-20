From: kustep <kustep@web.de>
Subject: unused space before data offset mismatch
Date: Wed, 20 Nov 2013 20:46:21 +0100
Message-ID: <528D118D.7090800@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Everyone,

is there an option to specifiy the "Unused Space : before=...."
Superblock information in mdadm -C ....?

My Raid crashed due to a controller error, but I was able to make the
new superblock almost identical to the old one (using mdadm -C
--assume-clean --level=6 --raid-devices=11 --chunk=256K --metadata=1.2
--bitmap=None --size=195328588 --data-offset=128768 /dev/md0
/dev/mapper/disk[cdefmbjkh] missing). Looking at mdadm --examine the
only difference left is:
old layout: Unused Space : before=257456 sectors, after=197632 sectors
new layout: Unused Space : before=257448 sectors, after=197632 sectors

Is there an option to change that or anything else I can do to make the
layouts identical? The assembled raid refuses to mount, and I suspect
this difference to be the reason.

Thanks in advance
Stephan
