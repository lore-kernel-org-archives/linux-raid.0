From: Andrew Walrond <andrew@walrond.org>
Subject: IDE performance question
Date: Sun, 8 Aug 2004 16:49:03 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408081649.03249.andrew@walrond.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got two 120Gb ide drives which I want to raid0 for performance, and my 
m/b has two IDE buses built in.

The linux-raid howto suggests putting one drive on each bus, because slave 
disks spoil performance.

Thats fine, I've got the usual two buses, but my question is: 

	Where should I put the CDROM drive?

Is the very existence of a slave device the source of the performance 
degredation, or just that the bandwidth has to be shared between the devices 
(so not a problem unless the cdrom is being accessed)?

Also, I remember from years ago that the cdrom could pull the whole bus down 
to some lower performance level (even if still using and 80wire cable?). Is 
this still the case? (The hardware in question is recent).

Knowledgeable advice sought :)

Andrew Walrond
