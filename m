From: William Morgan <therealbrewer@gmail.com>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Mon, 13 Jan 2020 16:40:31 -0600
Message-ID: <CALc6PW5DrTkVR7rLngDcJ5i8kTpqfT1-K+ki-WjnXAYP5TXXZg@mail.gmail.com>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
 <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk> <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
 <5E17D999.5010309@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E17D999.5010309@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >>> md1 consists of 4x 4TB drives:
> >>>
> >>> role drive events state
> >>>   0    sdj    5948  AAAA
> >>>   1    sdk   38643  .AAA
> >>>   2    sdl   38643  .AAA
> >>>   3    sdm   38643  .AAA

> If you're not happy using overlays, having ddrescue'd the disks you
> could always assemble the array directly from the copies and make sure
> everything's okay there, before trying it with the original disks.

I successfully ddrescued all four drives /dev/sd[j,k,l,m], each to new
disk, with no errors reported. I have the copies on /dev/sd[n,o,p,q].

Now if I want to force assemble the three copies with event counts
that agree [o,p,q], should I just do:

mdadm --assemble --force /dev/md1 /dev/sdo1 /dev/sdp1 /dev/sdq1

Or should I assemble the copies into a new array, say /dev/md2?

I'm worried that assembling the copies might merge them into the
existing (inactive) array. Is that what's supposed to happen? I'm
unclear here.

Thanks for your help,
Bill
