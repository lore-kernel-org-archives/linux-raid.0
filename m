From: "mousebusiness.com" <arturj@mousebusiness.com>
Subject: Adding spare drive
Date: Mon, 6 May 2002 22:42:28 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002901c1f579$464ec5a0$050010ac@niunia.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I will be building a RAID5 array with 5 data drives and one hot spare. I
need to use the drive for hot spare for something else at the moment. Is it
possible to build my array with 5 drives and add hot spare later by simply
adding the entry for it in /etc/raidtab?

The array will be built with 6 drives connected to 3 IDE controllers, one
per channel, 2 channels on each board. If one controller fails, obviously
the array will go down with it. Does that mean that all data will be
irrecoverably lost or will things go back to normal after I replace
defective controller and let the array resync?

I know these are basic questions, but I didn't find answers in FAQ (hint,
hint)

Comments greatly appreciated.

Artur

