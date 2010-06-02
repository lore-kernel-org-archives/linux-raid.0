From: Dan Christensen <jdc@uwo.ca>
Subject: Re: devices get kicked from RAID about once a month
Date: Wed, 02 Jun 2010 12:33:01 -0400
Message-ID: <871vcpo0n6.fsf@uwo.ca>
References: <87k4qho723.fsf@uwo.ca>
	<628039470-1275491015-cardhu_decombobulator_blackberry.rim.net-326486810-@bda837.bisx.prod.on.blackberry>
	<876321o3lm.fsf@uwo.ca> <4C067AD6.7040700@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson <john.robinson@anonymous.org.uk> writes:

> My Samsung Spinpoint F1's can have TLER enabled using a more recent
> smartctl. It's not appeared as part of a formal release yet but a
> patch went in to r3065 in SVN:
> http://sourceforge.net/apps/trac/smartmontools/log/trunk/smartmontools

Thanks.  I got the svn3077 from Debian testing, but it doesn't seem to
be supported with my drives:

# smartctl -l scterc /dev/sda
smartctl 5.40 2010-03-16 r3077 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen,
http://smartmontools.sourceforge.net

Warning: device does not support SCT Commands

Any other suggestions?

Dan

