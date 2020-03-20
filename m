From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Raid6 recovery
Date: Fri, 20 Mar 2020 19:15:07 +0000
Message-ID: <5E75163B.2050602@youngman.org.uk>
References: <CA+9eyijuUEJ7Y8BuxkKaZ=v8zbPpwixOezngPjtJzaLsBd+A4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+9eyijuUEJ7Y8BuxkKaZ=v8zbPpwixOezngPjtJzaLsBd+A4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Glenn Greibesland <glenngreibesland@gmail.com>, linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 19/03/20 19:55, Glenn Greibesland wrote:
> After a bit of digging in the manual and on different forums I have
> concluded that the next step for me is to recreate the array using
> –assume-clean and –data-offset=variable.
> I have tried a dry run of the command (answering no to “Continue
> creating array”), and mdadm accepts the parameters without any errors:

Oh my god NO!!!

Do NOT use --create unless someone rather more experienced than me tells
you to!!!

The obvious thing is to somehow get the sixteen drives that you know
should be okay, re-assembled in a forced manner. The --re-add should not
have done any real damage because, as mdadm keeps complaining, you
didn't have enough drives so it won't have touched the data on that
drive. Unfortunately, my fu isn't good enough to tell you how to get
that drive back in.

What's wrong with the two failed drives? Can you ddrescue them? They
might be enough to get you going again.

You say you've read the web page "Raid recovery" - which says it's
obsolete and points you at "When things go wrogn" - but you don't appear
to have read that! PLEASE read "asking for help" and in particular you
NEED to run lsdrv and give us that information. Without that, if you DO
run --create, you will be in for a world of hurt.

I know you may feel it's asking for loads of information, and the
resulting email will be massive, but trust me - the experts will look at
it and they will probably be able to come up with a plan of action. At
present, they don't have much to go on, and nor will you if carry on as
you're going ...

Cheers,
Wol
