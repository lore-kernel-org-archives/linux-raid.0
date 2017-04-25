From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Tue, 25 Apr 2017 11:01:22 +0200
Message-ID: <20170425090122.GA4488@metamorpher.de>
References: <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de>
 <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de>
 <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de>
 <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de>
 <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 25, 2017 at 10:44:15AM +0200, Patrik Dahlström wrote:
> Would that mean that I should be able to get the checksum to match if
> I remove one of the values in a mismatching series. I have tried this,
> but never got it correct.

No, there is no parity left with a missing drive in a raid5.

But you might find some duplicate blocks of one drive still in 5disk 
layout on the other drives where it would have ended up in 6disk layout.
You won't find all of them since there are parity blocks on both sides.
 
> Shouldn't I find something about it in my syslog or kernel log?

I suppose so, if you didn't boot a rescue/live system in between 
(they assemble raid and grow continues and whatever happens there 
is not in your logs).

Mind showing the --examine output of the two raid sets you're working 
with, did you check that the offsets are correct for either one?

You found multiple filesystem headers, do you know the UUID it should 
have so you're not working with some old remnant?

Not sure what to tell you really. :)
I hope things turn out to be simpler than they appear right now.

Good luck
Andreas Klauer
