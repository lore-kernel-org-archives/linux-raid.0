From: "Tim Harvey" <tharvey@alumni.calpoly.edu>
Subject: Ateonix NASAS 2040 NAS device - recovering RAID5 array
Date: Thu, 27 May 2004 15:15:55 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003201c44438$2fbd50d0$7001a8c0@darwin>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I have an Ateonix NASAS 2040 NAS device that has gone bad.  Specifically
the flash based OS (which is provided by a PCI 'flash disk' module made
by Ateonix) is not booting because of a power glitch while that occurred
obviously at a bad moment in time (while it was recovering from another
glitch I believe)).

Does anyone else out there have much knowledge of these devices?  I've
had mine running 24/7 for about 9 months now without incident.  I've
learned since that the company has gone out of business (unfortunate, it
was a great entry-level product).

I'm looking for anyone that may have firmware update files for it and
any knowledge on how it operates.  Specifically, I'm interested in
finding out how I can reset the unit to factory defaults while 'not'
loosing the data on the existing array.  Also, I'm curious if anyone has
found a way to get into the Linux OS (I've hooked up a keyboard/monitor
to the mboard, but I can't get any prompt, nor have I been able to find
any ports open for telnet/ssh).  Its not something they supported, but
I'm thinking there may be an unsupported/undocumented way.

Any info on this product would be greatly appreciated!

Thanks,

Tim

