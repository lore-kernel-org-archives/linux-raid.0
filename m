From: William Morgan <therealbrewer@gmail.com>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Mon, 20 Jan 2020 09:00:43 -0600
Message-ID: <CALc6PW5AmfFTYUzp74ucsiLGAOZ2HfSr839Vi=pQ1Peq-4eEFw@mail.gmail.com>
References: <CALc6PW4OKR2KVFgzoEbRJ0TRwvqi5EZAdC__HOx+vJKMT0TXYQ@mail.gmail.com>
 <959ca414-0c97-2e8d-7715-a7cb75790fcd@youngman.org.uk> <CALc6PW7276uYYWpL7j2xsFJRy3ayZeeSJ9kNCGHvB6Ndb6m1-Q@mail.gmail.com>
 <5E17D999.5010309@youngman.org.uk> <CALc6PW5DrTkVR7rLngDcJ5i8kTpqfT1-K+ki-WjnXAYP5TXXZg@mail.gmail.com>
 <CALc6PW7hwT9VDNyA8wfMzjMoUFmrFV5z=Ve+qvR-P7CPstegvw@mail.gmail.com>
 <5E1DDCFC.1080105@youngman.org.uk> <CALc6PW5Y-SvUZ5HOWZLk2YcggepUwK0N===G=42uMR88pDfAVA@mail.gmail.com>
 <5E1FA3E6.2070303@youngman.org.uk> <CALc6PW4-yMdprmube0bKku0FJVKghYt4tjhep26sy3F9Q5cB4g@mail.gmail.com>
 <20200120084944.GA8538@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200120084944.GA8538@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: William Morgan <therealbrewer@gmail.com>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> One is the UUID for the array (starting with "06ad") - this is what you
> use in /etc/mdadm.conf. The second is the UUID for the filesystem you
> have on the array (starting with "ceef") - that's used in /etc/fstab. If
> you recreate the filesystem then you'll get a different filesystem UUID
> but keep the same array UUID.
>
> Cheers,
>     Robin

Thank you Robin, this is helpful. Can you recommend some place to read
up on UUIDs and raid arrays, or some general UUID documentation?

Cheers,
Bill
