From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: TLER / CCTL timeout handling
Date: Wed, 24 Mar 2010 22:54:41 +0100
Message-ID: <4BAA8A21.8050601@stud.tu-ilmenau.de>
References: <4BA93C3F.2070208@gmail.com>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA93C3F.2070208@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 23.03.2010 23:10, schrieb Nebojsa Trpkovic:
> Hello.
> 
> I've found interesting text about TLER / CCTL
> (http://en.wikipedia.org/wiki/Time-Limited_Error_Recovery )

You might want to read on inside the ATA8-ACS, section about SCT Transport.
> 
> on desktop class drives:
> http://forums.storagereview.com/index.php/topic/28333-tler-cctl/
> 
> So, the question is:
> 
> If I make my drive report back it failed to read the requested sector,
> how that report will be handeled?

As far as I understood in recent answers to my questions: as expected.
> 
> Will Linux software RAID be aware of that report and start some action
> (rebuilding affected stripe or at least whole array, reallocating bad
> sectors along the way) ?
> 
Indeed.  Michael Tokarev answered to me on 2/9/10:
"On failed _read_ it tries to
reconstruct data from other disk drives and writes the reconstructed
data back to the drive where read failed.  If the _write_ fails md will
drop the disk."

This means: if read fails and the drive does not report back, the
following reconstructing write calls will fail, too.  The disk gets
dropped, because it (most probably) is still doing its error recovery on
the former read request and by that not responding.

If you enable ERC read timeouts, it'll report a media error (or
something similar), but honour the write request.  If you give the ERC
write timeout a value that is not too small and also not too large (i.e.
it shouldn't timeout the write-operation from the view of the kernel),
it will either fix the pending sector, or reallocate it.  If the ERC
write timeout value is too small, it'll very aggressively reallocate
sectors - which should not be the intention, as there are very few spare
sectors (compared to the amount of sectors in total - only a few thousand).
> 
> Thank you.
> Nebojsa Trpkovic

You're welcome, and all the best,
Stefan
