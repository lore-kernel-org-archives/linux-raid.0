From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 4] Introduction
Date: Tue, 02 Nov 2004 14:37:44 +1100
Message-ID: <20041102143440.12019.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are 4 patches for md/raid against 2.6.10-rc1-mm2.

1/ Fix problem with linear arrays if component devices are > 2terabytes
2/ Fix data corruption in (experimental) RAID6 personality
3/ Fix possible oops with unplug_timer firing at the wrong time.
4/ Add new md personality "faulty".
    "Faulty" can be used to inject faults and so test failure modes
    of other raid levels and of filesystes.

NeilBrown

