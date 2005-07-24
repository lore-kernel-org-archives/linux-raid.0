From: Ewan Grantham <ewan.grantham@gmail.com>
Subject: Software RAID on Windows using Embedded Linux?
Date: Sun, 24 Jul 2005 09:09:58 -0500
Message-ID: <6d5bedd8050724070995073e1@mail.gmail.com>
Reply-To: Ewan Grantham <ewan.grantham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I know, this is borderline, but figure this is the group of folks who
will know. I do a lot of audio and video stuff for myself and my
family. I also have a rather unusual networking setup. Long story
short, when I try to run Linux as my primary OS, I usually end up
reinstalling Windows after a couple weeks because there are still
holes in what I can do. That isn't the fault of Linux as much as folks
who write device drivers or have video codecs that require DirectShow.

However, the big thing I really miss from Linux that keeps me trying
to find a way to convert is the support for Software RAID 5.

It occured to me yesterday that perhaps the trick would be to use QEMU
to run Knoppix or Damn Small Linux under Windows, and then setup a
RAID 5 array under one of those. Not to mention then having access to
Linux for some other fun stuff.

I'm not sure if that's even possible, and if it is, how much trouble I
would have moving files around to and from the RAID array if it's
setup that way. So I'm wondering if anyone on the list has ever tried
this?

TIA,
Ewan
