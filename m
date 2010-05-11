From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Mon, 10 May 2010 22:04:32 -0500
Message-ID: <BE.8D.20763.249C8EB4@cdptpa-omtalb.mail.rr.com>
References: <4F.55.25297.BA4C8EB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F.55.25297.BA4C8EB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	On a related note, does anyone know of a good Linux Live CD which
enables both network operations (especially telnetd and ftpd) along with
mdadm?  I have a couple of Live CDs on hand, but they don't support mdadm or
remote access.  This is a headless system, and I really can't effectively
work with a local console, plus I need to mount the /boot array in order to
properly edit the initrd.  I suppose I could mount the drive as a non-array
and then force a sync to the second drive, but I'd rather not. 

