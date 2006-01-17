From: Sander <sander@humilis.net>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Tue, 17 Jan 2006 10:50:20 +0100
Message-ID: <20060117095019.GA27262@localhost.localdomain>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43CCA80B.4020603@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

Michael Tokarev wrote (ao):
> NeilBrown wrote:
> > Greetings.
> > 
> > In line with the principle of "release early", following are 5
> > patches against md in 2.6.latest which implement reshaping of a
> > raid5 array. By this I mean adding 1 or more drives to the array and
> > then re-laying out all of the data.
> 
> Neil, is this online resizing/reshaping really needed? I understand
> all those words means alot for marketing persons - zero downtime,
> online resizing etc, but it is much safer and easier to do that stuff
> 'offline', on an inactive array, like raidreconf does - safer, easier,
> faster, and one have more possibilities for more complex changes. It
> isn't like you want to add/remove drives to/from your arrays every
> day... Alot of good hw raid cards are unable to perform such reshaping
> too.

I like the feature. Not only marketing prefers zero downtime you know :-)

Actually, I don't understand why you bother at all. One writes the
feature. Another uses it. How would this feature harm you?

	Kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
