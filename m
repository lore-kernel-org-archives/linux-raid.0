From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: Two raid5 arrays are inactive and have changed UUIDs
Date: Sun, 19 Jan 2020 21:10:40 +0000
Message-ID: <917bd12e-3b76-2f27-8340-686dd71b1408@youngman.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALc6PW6r8jn7nJcq-ceTboRkP5TYj0863bo856SS3TAus0mTSA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: William Morgan <therealbrewer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/01/2020 20:12, William Morgan wrote:
> Still not sure why/dev/disk/by-id/  and/dev/disk/by-uuid/  would have
> differing UUIDs, but maybe that's normal.

Given that one is an ID, and the other is a UUID, I would have thought 
it normal that they're different (not that I know the difference between 
them! :-)

It would be nice if we had some decent docu on what all these assorted 
id's and uuid's and all that were, but I haven't managed to find any. 
Probably somewhere in the info pages for grub - given that I really 
don't like hypertext the fact that grub docu is very much hypertext is 
rather off-putting ...

Cheers,
Wol
