From: "Henrik Lewander" <henrik@lewander.com>
Subject: messed up raid5 array
Date: Tue, 25 May 2004 14:16:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <004001c44252$1845de00$7200a8c0@europe.ad.flextronics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

One disk failed in my four disk raid5 array this morning. I think I messed
up a bit, anyway it ended with that I removed all disks from the raid array.
Now when I add them again they show up as spares and I have no main disks at
all. Is there a way to force the three remaining disks (excluding the faulty
one) to be an array again and not lose the current data? If I do --create,
mdadm warns me that they are already a part of md1, yes but just as spares!
If I let mdadm do --create, I suppose I lose all the data? What can I do?

Really thankful for some insights here.

BR Henrik

