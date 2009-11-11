From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 08:54:31 -0600
Message-ID: <20091111145440822.LFBV5263@cdptpa-omta04.mail.rr.com>
References: <70ed7c3e0911110131o3819013fkf2d5096cfbb8d8c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0911110131o3819013fkf2d5096cfbb8d8c4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > mount -t ext2 /dev/hda4 /etc/mdadm/bitmap
> 
> I would suggest you mount the partition using UUID, just in case one
> day the disk decided to change its name, like what happened to me a
> while back.

	Yeah, I've had that happen with SATA drives quite a bit.  That's not
a bad idea.


