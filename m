From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 02:13:16 -0600
Message-ID: <20091111081325702.LZCS6968@cdptpa-omta02.mail.rr.com>
References: <70ed7c3e0911102122l3565cfat7a35a8a649237f56@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0911102122l3565cfat7a35a8a649237f56@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> If you have a temporary space for your data, I'd suggest you move it
> out and go for an internal bitmap solution. It certainly beats the

	For 8 Terabytes of data?  No, I don't.  I'm also not really keen on
interrupting the system ( in whatever fashion ) for six to eight days while
I copy the data out and back or taking the primary copy offline while I
re-do the array just so I can implement an internal bitmap.  It's much
easier to handle the external situation one way or the other.

> patch work you're going to have to do on the startup scripts (and
> every time you update mdadm, or the distro).

	That's why I am leaning strongly toward the lower value script,
which in fact I have already done.  Of course, it's also trivial to disable
it.  Updating mdadm or the distro won't affect the mount script.  At most I
would only have to rename the link, and then only if the mdadm startup link
gets re-numbered, which is unlilkely.  Creating the following script and one
symlink to it are hardly "patchwork" in any significant sense:

#! /bin/sh
# Explicitly mount /dev/hda4 prior to running mdadm so the write-intent
# bitmap will be available to mdadm

echo Mounting RAID bitmap...
mount -t ext2 /dev/hda4 /etc/mdadm/bitmap



