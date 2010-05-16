From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Sat, 15 May 2010 22:10:21 -0500
Message-ID: <93.23.23029.4226FEB4@cdptpa-omtalb.mail.rr.com>
References: <64.72.08602.22EFEEB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <64.72.08602.22EFEEB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	I've tried everything of which I can think, and then some.  This
system is still not bootable.  I even tried explicitly assembling the arrays
from within /scripts/local-top/mdadm inside the RAM disk, but it still won't
assemble the arrays, or at least won't mount them.  'Something I did notice
a few days ago, but I didn't think it would matter: Inside the initrd, the
array members show up as /dev/hdxy, while inside a fully booted system I
think they show up as /dev/sdxy.  Could it be there is a conflict between
the block device when mdadm is attempting to assemble the arrays prior to
mounting and when the system is attempting to mount the arrays?

