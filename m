From: Nix <nix@esperi.org.uk>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Fri, 24 Jan 2020 14:10:00 +0000
Message-ID: <87y2txvtc7.fsf@esperi.org.uk>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
        <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk>
        <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
        <5E17D999.5010309@youngman.org.uk>
        <CALc6PW5DrTkVR7rLngDcJ5i8kTpqfT1-K+ki-WjnXAYP5TXXZg@mail.gmail.com>
        <CALc6PW7hwT9VDNyA8wfMzjMoUFmrFV5z=Ve+qvR-P7CPstegvw@mail.gmail.com>
        <5E1DDCFC.1080105@youngman.org.uk>
        <CALc6PW5Y-SvUZ5HOWZLk2YcggepUwK0N===G=42uMR88pDfAVA@mail.gmail.com>
        <5E1FA3E6.2070303@youngman.org.uk>
        <CALc6PW4-yMdprmube0bKku0FJVKghYt4tjhep26sy3F9Q5cB4g@mail.gmail.com>
        <5E2494B3.9010006@youngman.org.uk>
        <CALc6PW6r8jn7nJcq-ceTboRkP5TYj0863bo856SS3TAus0mTSA@mail.gmail.com>
        <917bd12e-3b76-2f27-8340-686dd71b1408@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <917bd12e-3b76-2f27-8340-686dd71b1408@youngman.org.uk> (Wol's
        lists's message of "Sun, 19 Jan 2020 21:10:40 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Wol's lists <antlists@youngman.org.uk>
Cc: William Morgan <therealbrewer@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 Jan 2020, Wol's lists verbalised:
> It would be nice if we had some decent docu on what all these assorted id's and uuid's and all that were, but I haven't managed to
> find any. Probably somewhere in the info pages for grub - given that I really don't like hypertext the fact that grub docu is very
> much hypertext is rather off-putting ...

It's just perfectly ordinary Texinfo. There are lots of non-hypertext
output formats, e.g. plain text:
<https://www.gnu.org/software/grub/manual/grub/grub.txt.gz> or DVI:
<https://www.gnu.org/software/grub/manual/grub/grub.dvi.gz>. (Though the
DVI, like the PDF, contains specials that can implement hyperlinks if
your viewer can render them, I'm fairly sure the plain text version
doesn't.)

-- 
NULL && (void)
