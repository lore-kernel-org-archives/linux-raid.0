From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Tue, 17 Jan 2006 14:26:11 +0300
Message-ID: <43CCD453.9070900@tls.msk.ru>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru> <20060117095019.GA27262@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060117095019.GA27262@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: sander@humilis.net
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

Sander wrote:
> Michael Tokarev wrote (ao):
[]
>>Neil, is this online resizing/reshaping really needed? I understand
>>all those words means alot for marketing persons - zero downtime,
>>online resizing etc, but it is much safer and easier to do that stuff
>>'offline', on an inactive array, like raidreconf does - safer, easier,
>>faster, and one have more possibilities for more complex changes. It
>>isn't like you want to add/remove drives to/from your arrays every
>>day... Alot of good hw raid cards are unable to perform such reshaping
>>too.
[]
> Actually, I don't understand why you bother at all. One writes the
> feature. Another uses it. How would this feature harm you?

This is about code complexity/bloat.  It's already complex enouth.
I rely on the stability of the linux softraid subsystem, and want
it to be reliable. Adding more features, especially non-trivial
ones, does not buy you bugfree raid subsystem, just the opposite:
it will have more chances to crash, to eat your data etc, and will
be harder in finding/fixing bugs.

Raid code is already too fragile, i'm afraid "simple" I/O errors
(which is what we need raid for) may crash the system already, and
am waiting for the next whole system crash due to eg superblock
update error or whatnot.  I saw all sorts of failures due to
linux softraid already (we use it here alot), including ones
which required complete array rebuild with heavy data loss.

Any "unnecessary bloat" (note the quotes: I understand some
people like this and other features) makes whole system even
more fragile than it is already.

Compare this with my statement about "offline" "reshaper" above:
separate userspace (easier to write/debug compared with kernel
space) program which operates on an inactive array (no locking
needed, no need to worry about other I/O operations going to the
array at the time of reshaping etc), with an ability to plan it's
I/O strategy in alot more efficient and safer way...  Yes this
apprpach has one downside: the array has to be inactive.  But in
my opinion it's worth it, compared to more possibilities to lose
your data, even if you do NOT use that feature at all...

/mjt
