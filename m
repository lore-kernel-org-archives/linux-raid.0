From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Wed, 15 Jan 2020 23:44:38 +0000
Message-ID: <5E1FA3E6.2070303@youngman.org.uk>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
 <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk>
 <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
 <5E17D999.5010309@youngman.org.uk>
 <CALc6PW5DrTkVR7rLngDcJ5i8kTpqfT1-K+ki-WjnXAYP5TXXZg@mail.gmail.com>
 <CALc6PW7hwT9VDNyA8wfMzjMoUFmrFV5z=Ve+qvR-P7CPstegvw@mail.gmail.com>
 <5E1DDCFC.1080105@youngman.org.uk>
 <CALc6PW5Y-SvUZ5HOWZLk2YcggepUwK0N===G=42uMR88pDfAVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALc6PW5Y-SvUZ5HOWZLk2YcggepUwK0N===G=42uMR88pDfAVA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Morgan <therealbrewer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/01/20 22:12, William Morgan wrote:
> All 4 drives have the same event count and all four show the same
> state of AAAA, but the first and last drive still show bad blocks
> present. Is that because ddrescue copied literally everything from the
> original drives, including the list of bad blocks? How should I go
> about clearing those bad blocks? Is there something more I should do
> to verify the integrity of the data?

Read the wiki - the section on badblocks will be - enlightening - shall
we say.

https://raid.wiki.kernel.org/index.php/The_Badblocks_controversy

Yes, the bad blocks are implemented within md, so they got copied across
along with everything else. So your array should be perfectly fine
despite the badblocks allegedly there ...

Cheers,
Wol
