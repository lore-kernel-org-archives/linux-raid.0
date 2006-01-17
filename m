From: "Lincoln Dale \(ltd\)" <ltd@cisco.com>
Subject: RE: [PATCH 000 of 5] md: Introduction
Date: Wed, 18 Jan 2006 05:38:12 +0800
Message-ID: <26A66BC731DAB741837AF6B2E29C1017D47EA0@xmb-hkg-413.apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

> Neil, is this online resizing/reshaping really needed?  I understand
> all those words means alot for marketing persons - zero downtime,
> online resizing etc, but it is much safer and easier to do that stuff
> 'offline', on an inactive array, like raidreconf does - safer, easier,
> faster, and one have more possibilities for more complex changes.  It
> isn't like you want to add/remove drives to/from your arrays every
day...
> Alot of good hw raid cards are unable to perform such reshaping too.

RAID resize/restripe may not be so common with cheap / PC-based RAID
systems, but it is common with midrange and enterprise storage
subsystems from vendors such as EMC, HDS, IBM & HP.
in fact, I'd say it's the exception to the rule _if_ an
midrange/enterprise storage subsystem doesn't have an _online_ resize
capability..

personally, I think this this useful functionality, but my personal
preference is that this would be in DM/LVM2 rather than MD.  but given
Neil is the MD author/maintainer, I can see why he'd prefer to do it in
MD. :)


cheers,

lincoln.
