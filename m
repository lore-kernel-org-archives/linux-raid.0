From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Question about raid robustness when disk fails
Date: Wed, 27 Jan 2010 10:04:13 +0100
Message-ID: <87vden2a2a.fsf@frosties.localdomain>
References: <1262972385.8962.159.camel@kije>
	<87hbqeyua9.fsf@frosties.localdomain>
	<7d86ddb91001261619kbb77697t2660e5b8cc44535d@mail.gmail.com>
	<4877c76c1001262022p369eac60s639d87cad743ff94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1001262022p369eac60s639d87cad743ff94@mail.gmail.com>
	(Michael Evans's message of "Tue, 26 Jan 2010 20:22:56 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Ryan Wagoner <rswagoner@gmail.com>, Goswin von Brederlow <goswin-v-b@web.de>, Tim Bock <jtbock@daylight.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans <mjevans1983@gmail.com> writes:

> Why doesn't the kernel issue a pessimistic alternate 'read' path (on
> the other drives needed to obtain the data) if the ideal method is
> late.  It would be more useful for time-sensitive/worst case buffering
> to be able to customize when to 'give up' dynamically.

That is a verry good question. I look forward to seeing patches for this
from you. :) I think it isn't done because nobody has bothered to write
the code yet but maybe I'm wrong and it would make the code too
complicated.

MfG
        Goswin
