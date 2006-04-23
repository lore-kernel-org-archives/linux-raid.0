From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: to be or not to be...
Date: Sun, 23 Apr 2006 17:14:23 +0200
Message-ID: <62b0912f0604230814m675e947am140c0cfffa72465e@mail.gmail.com>
References: <20060423125836.GB6081@gelma.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060423125836.GB6081@gelma.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: gelma <dislessico@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

gelma wrote:
> first run: lot of strange errors report about impossible i_size
> values, duplicated blocks, and so on

You mention only filesystem errors, no block device related errors.
In this case, I'd say that it's more likely that dm-crypt is to blame
rather than MD.

I think you should try the dm-devel mailing list.  Posting a complete
log of everything that has happened would probably be a good thing.

I have no experience with dm-crypt, but I do have experience with
another dm target (dm-snapshot), which iss very good at destroying my
data.

If you want a stable solution for encrypting your files, I can
recommend loop-aes.
loop-aes has very well thought-through security, the docs are concise
but have wide coverage,
it has good backwards compatibility - probably not your biggest
concern right now, but it is *very* nice to know that your data is
accessible, in the future as well as now - etc..  I've been using it
for a couple of years now, since the 2.2 or 2.4 days (can't remember),
and I've had nothing short of an absolutely *brilliant* experience
with it.

Enough propaganda for now, hope that you get your problem solved :-).
