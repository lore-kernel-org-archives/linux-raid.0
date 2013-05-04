From: Neil Matai <neil@matai.kiwi.nz>
Subject: Simultaneous assembly on multiple hosts
Date: Sat, 4 May 2013 14:01:46 +1200
Message-ID: <20130504020146.GD31411@chc-5.metaname.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Is it dangerous have an array assembled on two hosts at the same time?
Say I have servers A and B exporting devices a and b via ATA over
Ethernet or similar to hosts C and D.  If a and b are components of an
array then both C and D automatically assemble the array as soon as
the components a and b are exported but is this safe (on the proviso
that only one of C or D is ever writing to the array at any time and
that there is no write-behind caching above the array device)?

Thank you,

- neil

