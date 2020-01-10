From: William Morgan <therealbrewer@gmail.com>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Thu, 9 Jan 2020 19:19:08 -0600
Message-ID: <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
 <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wol's lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for the encouraging response. I think I would like to
attempt to rescue the smaller array first as the data there is
somewhat less crucial and I may learn something before working with
the more important larger array.

> > md1 consists of 4x 4TB drives:
> >
> > role drive events state
> >   0    sdj    5948  AAAA
> >   1    sdk   38643  .AAA
> >   2    sdl   38643  .AAA
> >   3    sdm   38643  .AAA
>
> This array *should* be easy to recover. Again, use overlays, and
> force-assemble sdk, sdl, and sdm. DO NOT include sdj - this was ejected
> from the array a long time ago, and including it will seriously mess up
> your array. This means you've actually been running a 3-disk raid-0 for
> quite a while, so provided nothing more goes wrong, you'll have a
> perfect recovery, but any trouble and your data is toast. Is there any
> way you can ddrescue these three drives before attempting a recovery?

I do have plenty of additional disk space. If I try ddrescue first,
will that just give me a backup of the array in case something goes
wrong with the force-assemble with overlays? Can you give me some
guidance on what to do with ddrescue?

Thanks,
Bill
