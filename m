From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Mon, 10 May 2010 21:50:29 -0500
Message-ID: <94.66.20763.7F5C8EB4@cdptpa-omtalb.mail.rr.com>
References: <4BE83D28.3000508@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BE83D28.3000508@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Bill Davidsen' <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 
> I have zero experience with debian, but on several other distributions I
> have noted that an upgrade to a very recent kernel from a fairly old
> kernel (which you did) will make the LVM not work if you're using that.

	By "that", you mean LVM?  No, straight MD RAID 1.

> If not, forget I said it, it's not related and I never chased it, I just
> saw it a few times and muttered mighty oaths and moved on.

	Oh, it's almost surely related to the new version of udev.  John
Robinson's response makes it clear udev is assigning a different block
device (sdx vs mdx), whihc is probably why it's failing.  I did try
different targets, and /dev/hda and /dev/hdb definitely do not exist.  I'll
look for sda and sdb when I get the chance.  'Should be an easy fix if
that's all it is.

