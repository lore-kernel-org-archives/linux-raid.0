From: Jurriaan <thunder7@xs4all.nl>
Subject: Re: Fresh setup....
Date: Mon, 20 Sep 2004 19:20:57 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040920172057.GA8372@middle.of.nowhere>
References: <6F9171BE257CA742BFBCFA87B8F20F8D030E3CB2@NZURC900PEX1.ubsgs.ubsgroup.net>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6F9171BE257CA742BFBCFA87B8F20F8D030E3CB2@NZURC900PEX1.ubsgs.ubsgroup.net>
To: peter.greis@ubs.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: peter.greis@ubs.com <peter.greis@ubs.com>
Date: Mon, Sep 20, 2004 at 03:21:26PM +0200
> OK, I believe that I have determined that I need a newer kernel (2.6.7 or later) to get this new mobo running (Asus K8N-E deluxe) with RAID-1 OS disks. Is my only option here to build up the system on a normal IDE drive, get the kernel rebuilt and up to date, configure the raid, then "dd" the partitions over ?
> 
Why not just unplug one of the drives and resync when you have your new
kernel up and running? The usual precautions apply (tested backups etc).

Good luck,
Jurriaan
-- 
Linux is obsolete
	Andrew Tanenbaum
Debian (Unstable) GNU/Linux 2.6.9-rc1-mm4 2x6209 bogomips load 1.38
