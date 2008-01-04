From: "Thiemo Nagel" <thiemo.nagel@ph.tum.de>
Subject: Re: On the subject of RAID-6 corruption recovery
Date: Sat, 5 Jan 2008 00:59:27 +0100 (CET)
Message-ID: <59840.88.217.65.202.1199491167.squirrel@www.e18.physik.tu-muenchen.de>
References: <4774663C.5090609@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4774663C.5090609@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear hpa,

H. Peter Anvin wrote:
> I got a private email a while ago from Thiemo Nagel claiming that
> some of the conclusions in my RAID-6 paper was incorrect.  This was
> combined with a "proof" which was plain wrong, and could easily be
> disproven using basic enthropy accounting (i.e. how much information
> is around to play with.)
>
> However, it did cause me to clarify the text portion a little bit. In
> particular, *in practice* in may be possible to *probabilistically*
> detect multidisk corruption.  Probabilistic detection means that the
> detection is not guaranteed, but it can be taken advantage of
> opportunistically.

Thank you very much for setting me straight concerning some of my
misconceptions about raid 6.  Yet, the point that I was trying to make
was that the statement "multidisc corruption cannot be detected" -- while
correct in a mathematical sense -- is misleading when considering
practical application, and I feel confirmed in that by your reply.

> There are two patterns which are likely to indicate multi-disk
> corruption and where recovery software should trip out and raise
> hell:
>
> * z >= n: the computed error disk doesn't exist.
>
> Obviously, if "the corrupt disk" is a disk that can't exist, we have
> a bigger problem.
>
> This is probabilistic, since as n approaches 255, the probability of
> detection goes to zero.
>
> * Inconsistent z numbers (or spurious P and Q references)
>
> If the calculation for which disk is corrupt jumps around within a
> single sector, there is likely a problem.

Inverting your argumentation, that means when we don't see z >= n or
inconsistent z numbers, multidisc corruption can be excluded statistically.

For errors occurring on the level of hard disk blocks (signature: most
bytes of the block have D errors, all with same z), the probability for
multidisc corruption to go undetected is ((n-1)/256)**512.  This might
pose a problem in the limiting case of n=255, however for practical
applications, this probability is negligible as it drops off
exponentially with decreasing n:

n=255  p=1.8%
n=250  p=6.8e-7
n=240  p=5.3e-16
n=10   p=3.6e-745

So it seems to me that for that case, implementing recovery would be
safe (maybe limit it to n<240).


For errors occurring on the byte level (signature: only one byte of a
sector has D error, all other bytes have no error), multidisc corruption
is highly unlikely due to a different argumentation:  Since 511 out of
512 bytes are ok, it can be concluded, that for errors in this specific
sector, there is no correlation between the individual disks.  That
means, that the probability for double corruption is approximately
8*(n-1)*BER, and the bit error rate (BER) should be low.  (For
comparison:  Some vendors specify 1e-15 as probability of unrecoverable
read error (per bit that is read).  I'd assume that the probability of
silent read errors is much lower, at least for the disk itself; however
additional errors might be introduced in (S)ATA transfer or in the
controller.)

For that case, too, it seems to me that implementing recovery could do
no harm.


Kind regards,

Thiemo Nagel


