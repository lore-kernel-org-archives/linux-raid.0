From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: sorta OT:  vibration dampening, maximum promise cards?
Date: Tue, 26 Aug 2003 09:28:32 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0308260924260.24071-100000@multivac.sdsc.edu>
References: <bWpzdHVtcGY=.c5d8810eb73f976c7b8c14372ac7b762@1061912233.cotse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bWpzdHVtcGY=.c5d8810eb73f976c7b8c14372ac7b762@1061912233.cotse.net>
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 26 Aug 2003, mjstumpf wrote:

> 2)  Anyone know what the limit of the newer "tx2" promise 2-channel ATA
> cards is in a given system?  I read somewhere the older ones were limited
> to 3..  I'm at 3 now.

To the best of my knowledge, the Promise Ultra-100 and Ultra-133 cards
have BIOS limitations, which only allow two cards to be used at the same
time.  There may be ways to 'trick' the BIOS to recognize a third card,
but I don't know of any.  I have never heard of anyone getting a fourth
card to work.

Now for the good news.  The BIOS for the Ultra-100 doesn't know about the
Ultra-133 and vice versa.  This means that, as far as the BIOS is
concerned, two Ultra-100 cards and two Ultra-133 cards should work in the
same system.  I don't know what the Linux drivers would do in this case,
as I've only done this under Windoze.

I hope this helps.
				Peter Ashford

