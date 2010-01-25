From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Question about raid robustness when disk fails
Date: Mon, 25 Jan 2010 18:51:25 +0100
Message-ID: <87636qqdia.fsf@frosties.localdomain>
References: <1262972385.8962.159.camel@kije>
	<87hbqeyua9.fsf@frosties.localdomain> <1264436547.3015.24.camel@kije>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264436547.3015.24.camel@kije> (Tim Bock's message of "Mon, 25
	Jan 2010 09:22:27 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bock <jtbock@daylight.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Bock <jtbock@daylight.com> writes:

> Thank you for the response.  Through the smartctl tests, I noticed that
> the "seek error rate" value for the misbehaving disk was at 42, with the
> threshold at 30.  For other disks in the same array, the "seek error
> rate" values were up around 75 (same threshold of 30).  As it seems the
> values decrement to the threshold, I took that as a further sign that
> the disk was in trouble and replaced it.  Any likely correlation between
> the described problem and the "seek error rate" value?

Always keep in mind that smart values are often random, fictional or
garbage. I have disks that have an airflow temperature (outside) of 80+
and temperature (inside) of 50+. Both going down as the disk heats up
from use.

The only values I would keep a close eye on is remapped sectors and
pending sectors. Anything else gives nice graphs but I always feel is
totaly useless. And even the pending sectors are != 0 on one drive while
badblocks reports no errors on repeated passes. The drive just doesn't
seem to reduce the count when it successfully remaps a sector.

MfG
        Goswin
