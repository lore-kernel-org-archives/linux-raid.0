From: Gordon Henderson <gordon@drogon.net>
Subject: Dell + Adaptec SATA RAID controller...
Date: Tue, 22 Mar 2005 09:25:12 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0503220918550.28150@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


As part of a (Dell) server purchase, a client was given a free Dell 750
PowerEdge (Celeron) box with 2 x 120GB SATA drives... Opening the lid (as
you do :)  revealed that the motherboard has on-board SATA, but Dell had
also plugged in an Adaptec 6-port SATA RAID card, and connected the 2
drives to that.

Now I'm wondering why Dell have the capacity to give away free servers (I
know someone else who got a free server out of them a while back) and why
they'd put in a (presumably) expensive RAID controller...

Maybe the mobo controllers are knackererd in some way?

Anyway, I'm tempted to just remove the Adaptec card and give the on-board
controllers a go using s/w RAID which I know and love...

Anyone got any comments either way?

Cheers,

Gordon
