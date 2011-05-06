From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: wish for Linux MD mirrored raid types
Date: Fri, 6 May 2011 09:17:52 +0200
Message-ID: <20110506071752.GA22063@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List

based on the recent discussion, that showed lacking knowledge
on Linux MD RAID10 features, I have some thoughts:

It is really hard to disseminate information on "new" features
in MD RAID. RAID10 has been in the kernel since 2.6.9 - from 2004.
I have tried to give info on RAID10 at a number of web pages,
and still many people, even on our linux-raid list are not aware
of it.

Also many people are confused about Linux MD raid10 and RAID1+0.

So I think we shopuld rather name things in another way.

I would like linux MD raid10 functionality to be part of the Linux MD
RAID1 module, and be called raid1. This is in accordance with the
use of the RAID1 term as standadized by SNIA. In fact the RAID10-offset
layout is an implementation of a SNIA RAID specification. The RAID10-near
layout is an implementation of a simple RAID layout. And the RAID10-far
layout is just another layout far a mirrored RAID.  So all these types
could just be defined as different RAID1 layouts.

I would then also wish for RAID10-far to be the default RAID1
layout. There is general agreement on this list that RAID10-far
is the best mirrored layout for most purposes. In the interest of giving
the best performance to the Linux RAID users, we should make
the defaults the best practise - users tend to choose defaults,
especially often they do not have much knowledge. 

We could still keep the RAID10 code for backwards compatibility,
or even let this new naming just be calls to the raid10 code
from the raid1 module.

best regards
Keld
