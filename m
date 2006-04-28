From: John Rowe <rowe@excc.ex.ac.uk>
Subject: RAID-related: SATA disk removal?
Date: Fri, 28 Apr 2006 16:55:57 +0100
Message-ID: <1146239757.10253.122.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am testing a machine with two SATA drives in startech.com removable
caddies. Everything including swap is RAID1. (I'm running x86_64
Scientific Linux 4.2, a RedHat enterprise clone.)

Informal tests suggest that pulling out an active disk causes the whole
machine to hang up but removing a disk from the RAID arrays and pulling
it out gives the message: "nv_sata: Primary device removed" and
everything happily keeps running.

Is this a fair description? In practise do people find that following
the above allows a failed disk to be replaced without shutting down the
machine? 

Thanks

John


