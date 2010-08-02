From: Ben Nemec <lists@nemebean.com>
Subject: Replacing a drive in RAID 0
Date: Mon, 02 Aug 2010 17:18:11 -0500
Message-ID: <1c7fae50481e2f053798107bf2ad2737@localhost>
Reply-To: lists@nemebean.com
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I have a disk in a RAID 0 array that SMART tells me is dying, but hasn't
died yet.  I have a warranty replacement on the way, and I'm wondering if
there's any way to copy the data off the dying drive to the new drive and
swap the RAID array to use the new one (assuming the old one lasts long
enough to do that, of course).  Can I just dd the entire drive over and
replace the bad drive?  Can the md tools do it somehow?  Maybe it's
impossible?  Obviously nothing on this array is irreplaceable, but it would
save me some hassle reinstalling things if I could save it.

Thanks.

-Ben
