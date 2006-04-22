From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: data recovery on raid5
Date: Sun, 23 Apr 2006 00:58:58 +0200
Message-ID: <62b0912f0604221558l5af17b3cn1a44dc06e04a27ad@mail.gmail.com>
References: <444A7C99.80006@abhost.net>
	 <62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>
	 <444A8D04.20809@abhost.net>
	 <62b0912f0604221322k25c96c37q2bee9361a6316c1b@mail.gmail.com>
	 <444A92CF.70401@abhost.net>
	 <62b0912f0604221338m6b9fc06do61d78ffa622523bc@mail.gmail.com>
	 <444A9841.8070202@abhost.net>
	 <62b0912f0604221417g3f539b9aub9c4fa82ab78faaf@mail.gmail.com>
	 <17482.41801.445052.11179@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17482.41801.445052.11179@fisica.ufpr.br>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carlos Carvalho wrote:
> Is it my turn now?

Hah, nah, based on your postings you seem to know more about MD than I do ;-)

> [UUUUUU__UUUUUU_]
>
> This is a 15-array + spare where 3 or 4 disks dropped, *very* likely
> because of these miserable crappy sata power connectors :-( :-(

They really suck, don't they.
I had a SATA data connector that was slightly skewed the other day, no
more than 1.5mm, and it caused random read errors.  Gah.

> It's unbelievable that the industry changes from a working standard
> to an unreliable trash in such common and widespread devices...

Yes. Sigh..

> I'm trying to get enough stamina to put the damn thing back on line...

Guess it's just --assemble --force and then cross your fingers...

Hmm, your mdstat does look a bit weird.
Why wasn't the spare taken into use on md4?

Perhaps you should check the event counters.
Just in case the spares got added late in the game, got half-rebuilt
and the MD crapped out?
Wouldn't want to include them in the assemble in that case...
(Dunno if it could even happen.  Hopefully not =))
