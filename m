From: murray evans <m.evans@rdg.ac.uk>
Subject: hostRAID, AIC-7901, disable?
Date: Mon, 13 Dec 2004 16:04:08 +0000
Message-ID: <cpkem3$70s$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We have recently aquired a new Dell Precision 670 workstation, on which
we intended to install linux, (Suse 9.1). 
In the install, is reports it can not find any hard drives.
We think we have tracked this problem down to the AIC-7901 hostRAID
SCSI controller. From what I we can gather, linux no longer has
drivers for hostRAID hardware. We don't care about having RAID, just
a working system, so we would be content to simply disable the 
hostRAID. the problem is, the setup tool does not have any option
to disable hostRAID.

Has anyone come across a solution? Is there a driver I don't know of?
Is there a way of disabling hostRAID?

*PS: From the SuSe install, when we try to add the appropriate SCSI
module for the AIC-7901, it fails.

