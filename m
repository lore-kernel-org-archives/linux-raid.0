From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Requesting replace mode for changing a disk
Date: Sat, 09 May 2009 00:15:35 +0200
Message-ID: <8763gb44xk.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

consider the following situation: You have a software raid that runs
fine but one disk is suspect (e.g. SMART says failure imminent or
something). How do you replace that disk?

Currently you have do fail/remove the disk from the raid, add a
fresh disk and resync. That leaves a large window in which redundancy
is compromised. With current disk sizes that can be days.

It would be nice if one could tell the kernel to replace a disk in a
raid set with a spare without the need to degrade the raid.

Thoughts?

MfG
        Goswin
