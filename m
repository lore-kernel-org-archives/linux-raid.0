From: David Dougall <davidd@et.byu.edu>
Subject: No response?
Date: Thu, 20 Jan 2005 10:55:56 -0700 (MST)
Message-ID: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Perhaps I was asking a stupid question or an obvious one, but I have
received not response.
Maybe if I simplify the question...

If I am running software raid1 and a disk device starts throwing I/O
errors, Is the filesystem supposed to see any indication of this?  I
thought software raid would mask all of this and just fail the drive.

I have servers with xfs as the filesystem and xfs will start to throw I/O
errors when a disk starts acting up even with software raid in between.
Please advise on how I can confirm my setup or if this is possibly a bug
how to diagnose further.
If it makes a difference, I am running linux-2.4.26
Thanks
--David Dougall

