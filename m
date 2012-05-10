From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 16:15:30 -0500
Message-ID: <4FAC2FF2.5060305@hardwarefreak.com>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FABC7C6.4030107@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Marcus Sorensen <shadowsor@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/10/2012 8:51 AM, Phil Turmel wrote:

> Hardware RAID cards usually offer battery-backed write cache, which is
> very valuable in some applications.  I don't have a need for that kind
> of performance, so I can't speak to the details.  (Is Stan H.
> listening?)

Yes, I'm here to drop the hammer, and start a flame war. ;)  I've been
lurking and trying to stay out of the fray, but you "keep dragging me
back in!" --Michael Corleone

I find the mere existence of this thread a bit comical, as with all
others that have preceded it.  I made the comment on this list quite
some time ago that md raid is mostly used by hobbyists, and took a lot
of heat for that.  The existence of this thread adds ammunition to that
argument.

If not for the fact Western Digital added "TLER" to the spec sheet of
it's RE and Raptor series drives many years ago, nobody would have every
mentioned it.

WD did this because those in the "channel" marketplace weren't buying
the drives.  They saw no difference with these new "enterprise" drives
but the much higher price.  WD has never sold RE/Raptor drives to
server/storage OEMs.  WD has never had a presence in enterprise storage.
 Seagate, Hitachi/IBM, Fujitsu, and to a small degree Toshiba, have
owned that space for over a decade.

So in an attempt to drive sales, they added "TLER" to the sheet to
differentiate from their desktop drives.  So what happens?  All the
hobbyists immediately want to enable this "TLER" feature from the
"enterprise" drives on their consumer models, because "TLER" is all that
makes them "enterprise" drives, after all, "all WD drives are the same,
just with different firmware, right?".

Proof point:  Few write about this subject using the generic term "ERC",
which is used by Seagate, or the term Samsung uses, "CCTL".  Everyone
seems to talk about "TLER".  Hmmm...  Coincidence?  No, marketing.

You won't find a single discussion about ERC/TLER/CCTL on any enterprise
storage forum, unless its brought up by someone desiring to cut cost
corners using consumer drives.

So if md raid is not limited to use by hobbyists, and is indeed used in
enterprise environments, then why aren't the enterprise boys discussing
"the problems w/TLER and enterprise drives"?  Because obviously md raid
has no issues when being used with enterprise (ERC/TLER/CCTL) drives.

Either that, or md raid is only used by hobbyists. ;)

-- 
Stan
