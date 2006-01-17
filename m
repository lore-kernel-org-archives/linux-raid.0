From: Francois Barre <francois.barre@gmail.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Tue, 17 Jan 2006 12:37:13 +0100
Message-ID: <fd8d0180601170337y52d68161j@mail.gmail.com>
References: <20060117174531.27739.patches@notabene>
	 <43CCA80B.4020603@tls.msk.ru>
	 <20060117095019.GA27262@localhost.localdomain>
	 <43CCD453.9070900@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43CCD453.9070900@tls.msk.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/1/17, Michael Tokarev <mjt@tls.msk.ru>:
> Sander wrote:
> This is about code complexity/bloat.  It's already complex enouth.
> I rely on the stability of the linux softraid subsystem, and want
> it to be reliable. Adding more features, especially non-trivial
> ones, does not buy you bugfree raid subsystem, just the opposite:
> it will have more chances to crash, to eat your data etc, and will
> be harder in finding/fixing bugs.
>
> Raid code is already too fragile, i'm afraid "simple" I/O errors
> (which is what we need raid for) may crash the system already, and
> am waiting for the next whole system crash due to eg superblock
> update error or whatnot.  I saw all sorts of failures due to
> linux softraid already (we use it here alot), including ones
> which required complete array rebuild with heavy data loss.
>
> Any "unnecessary bloat" (note the quotes: I understand some
> people like this and other features) makes whole system even
> more fragile than it is already.
>
> Compare this with my statement about "offline" "reshaper" above:
> separate userspace (easier to write/debug compared with kernel
> space) program which operates on an inactive array (no locking
> needed, no need to worry about other I/O operations going to the
> array at the time of reshaping etc), with an ability to plan it's
> I/O strategy in alot more efficient and safer way...  Yes this
> apprpach has one downside: the array has to be inactive.  But in
> my opinion it's worth it, compared to more possibilities to lose
> your data, even if you do NOT use that feature at all...
>
> /mjt

I do agree with you about that : the lesser the code, the fewer the
bugs. Of course.
But I do think that Linux would not have become what it is now if
each-and-every new feature was debated for years and years about their
risk.
Anyway, having a suspiously bogus raid5 resize is not a fatality :
what about having a 'parano=EFd' option/strategy, decreasing performanc=
e
but mirroring superblocks on another device (not necessarily on the
array), logging/journalling loads of stuff (metadata quite
exclusively), and making resize much much stronger ?
I prefer having my raid5 online and have a resize time of 12 hours
than putting it offline and have a resize time of 2 hours.
This is not marketting, this is the way computers shall behave :-p.
Trustworthy features and flexibility in the same box.

=46.-E.B.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
