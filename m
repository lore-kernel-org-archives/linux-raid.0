From: Peb <peb-misc@peeble.net>
Subject: md array numbering is messed up
Date: Sun, 29 Oct 2006 22:17:00 +0100
Message-ID: <45451A4C.9010708@peeble.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have 2 arrays whose numbers get inverted, creating havoc, when booting
under different kernels.

I have md0 (raid1) made up of ide drives and md1 (raid5) made up of five
sata drives, when booting with my current ubuntu 2.6.12-9 kernel. When I
try to boot a more recent kernel (2.6.15-26 or 2.6.15-27) the
order is inversed and my sata raid5 array shows up as md0.

My arrays are part of evms volumes that just stop working if the
numbering is inverted.

any clues ?

thanks,
Pierre
