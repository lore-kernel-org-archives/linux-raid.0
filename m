From: Michael Robinton <michael@insulin-pumpers.org>
Subject: raid 1 fails twice
Date: Mon, 13 Dec 2004 22:27:47 -0800 (PST)
Message-ID: <Pine.LNX.4.33.0412132220580.25904-100000@pandora.is.bizsystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 2.4 linux raid 1 on an ASUS mother board. One of the drives
failed yesterday and a couple of hours ago I replaced it with a spare I had
on the shelf. Now, when the re-sync should be complete I find the new
drive also failed and making noise that indicates the controller thrashing
the drive arm around (clink, clink, clink). The controllers are integrated
into the mbrd so I would not expect them to fail without other problems
manifesting themselves. Anyone care to take a guess at what's going on,
I'm stumped? In all other respects the system seems to perform normally.
It is a production web server on-line 24x7

2 20gig WD205AA
SIS 5518 chipset

Michael


