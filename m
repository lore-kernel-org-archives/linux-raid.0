From: "John Stoffel" <john@stoffel.org>
Subject: Re: help with bad performing raid6
Date: Thu, 30 Jul 2009 16:30:33 -0400
Message-ID: <19058.745.523273.951106@stoffel.org>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
	<4A7065F1.3060203@tmr.com>
	<002801ca1066$7f30be90$7d923bb0$@id.au>
	<4A719CD6.1060801@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A719CD6.1060801@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Steven Haigh <netwiz@crc.id.au>, 'Jon Nelson' <jnelson-suse@jamponi.net>, 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


You could also be running into PCI bus bandwidth issues.  And since
you say you're using a 100Mb/s network link you're never going to get
more than 10MByete/sec out of NFS, and probably much worse.  Check
your 'netstat -ni' output as well and see if you have collisions or
other network issues.

Can you shuffle around PCI boards (if you have multiple busses on the
server) or maybe switch to gigabit cards as well?

John
