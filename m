From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: RAID5 over Serial-ATA success stories?
Date: Wed, 7 Jan 2004 22:36:57 +0100
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <20040107223657.A5315@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'd like to hear some success stories for RAID5 on Serial-ATA disks.
Which Serial-ATA card are you using?  Do you get decent performance?
Is it stable with DMA enabled?  Do you use the 2.4 or 2.6 kernel?

I know this much:

It doesn't work with Silicon Image.
It doesn't work with VIA (yet, anyway).
It might work with HighPoint.
It probably works with Promise.
I don't know if there's a driver for Adaptec.

In case I have to replace my Silicon Image card, what should I replace
it with?  I'm currently leaning towards Promise TX4 (or TX2 if the VIA
driver is completed).

Lots of thanks,

/Basic

