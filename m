From: John K Luebs <jkluebs@luebsphoto.com>
Subject: Write cache / barrier
Date: Sun, 12 Nov 2006 01:00:16 -0500
Message-ID: <20061112060016.GA15554@kabir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'm using md devices. What I don't understand is how things with the
raid are kept safe when write caching is enabled on the underlying
devices. Forgetting filesystem integrity, if a write access hits
one of the disks and the power goes out, won't the members of the array
be inconsistent without the md layer knowing about it?

For now I am running with write caching turned off.

Also, some drives support write cache flushing and some do not. Does
this make any difference to md?

 Thanks,
   -jkl
