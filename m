From: Chris Murphy <lists@colorremedies.com>
Subject: Re: mdadm expanded 8 disk raid 6 fails in new server, 5 original devices show no md superblock
Date: Mon, 13 Jan 2014 13:11:37 -0700
Message-ID: <D71A830E-3DB0-428D-8ED7-AD07E92B9B0A@colorremedies.com>
References: <1389422546.11328.15.camel@achilles.aeskuladis.de>	 <52D183B5.3060006@turmel.org> <1389632980.11328.104.camel@achilles.aeskuladis.de> <52D4337F.4050307@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52D4337F.4050307@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 13, 2014, at 11:42 AM, Phil Turmel <philip@turmel.org> wrote:

> Do *not* buy desktop drives!  You need raid-capable drives like the WD
> Red at the least.


Yeah I agree. If you care about the data, suck it up and use the right drive.

Very slight threadjack here: WD has a Caviar and Scorpio Blue, and all of the models I've seen, both desktop and laptop interestingly enough, have SCT ERC support. They are "tested and recommended" for raid0/raid1 only. WD says they are not warranted for use in (among other things) "multi-bay chassis" even though they don't list raid5 by name. I think the question is whether vibration is a concern with this class of drive, which then points a typical user to the Caviar/Scorpio Black which has the same recommendation and proscription as the Blue, *but* at least one desktop and one laptop Black model I have, do not support SCT ERC.

So it's almost like spec wise the Red has the vibration tolerance of the Black, but the SCT ERC support the Blue has. It's just odd they do it this way though. And finding out what drives have SCT ERC support is non-obvious.

Chris Murphy

