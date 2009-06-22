From: <Ryan_MichaelS@emc.com>
Subject: Slow raid10 resync
Date: Mon, 22 Jun 2009 13:34:17 -0400
Message-ID: <2A22ECE278A6604A84476172F106BFCE07AC7A5A@CORPUSMX50A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Occasionally one of my devices with a 4 drive raid10 array resyncs very
slowly.  Typical resync speed is in the 50-60 MB/sec range.  When
running slow the speed is around 7-10 MB/sec.  sync_speed_min is set to
20,000, max is set to 200,000.  By setting sync_speed_min to 5000 I can
slow the sync further, but setting it back to 20000 doesn't fix the
speed.  Other IO on the system is normal.  The drives and the CPU are
not maxed.

I don't know what is triggering this slow sync state.  Once in this
state it will continue until the build completes.

Any idea what might be happening here?  I'm running Debian with a 2.6.22
kernel.

Thanks for your help.
- Michael
