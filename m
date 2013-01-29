From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Tue, 29 Jan 2013 18:49:44 +0100
Message-ID: <20130129174944.GA2396@lazy.lzy>
References: <20130127192656.634892005AD@gemini.denx.de>
 <20130128173704.GA2329@lazy.lzy>
 <20130128190035.D943A294BAB@gemini.denx.de>
 <20130128191041.8E962200607@gemini.denx.de>
 <20130128192256.GB13803@lazy.lzy>
 <20130128201947.2B615200607@gemini.denx.de>
 <20130128204422.GA14115@lazy.lzy>
 <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 28, 2013 at 03:47:13PM -0700, Chris Murphy wrote:
[...]
> In RAID 6 are the two parity chunks in a stripe identical? If yes, does 'unknown' only tell us that the data chunk recomputed parity does not match either of the parity chunks; or does it tell us anything about whether the parity chunks themselves are still the same or different?

Hi Chris,

the two parities, P and Q, are not the same,
they're different Reed-Solomon polynomials.

You'll find more detail here:

http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf

At the end of this document, it is explained
what I've implemented in raid6check.
The process is the following.
The data is read (per stripe) and P, Q are
then calculated.
If the read P and Q are the same as the
calculated ones, then it is *assumed* the
data is OK.
If P *or* (xor) Q does not match, then it
is *assumed* the non matching one is wrong.

If both, P and Q, do not match, then there
is a calculation which returns us the slot
(chunk position, if you want) where the
error could be.
If the slot is not in the ammissible range,
for example if we have 5 data disk (0 to 4)
and the calculation returns 10, then it
means the error cannot be detected, which,
in turn, means probably more than one slot
has errors.

The "unknown" above states exactly this,
the two parities are not matching (P wrong,
Q wrong at the same position) and the
calculation cannot find which slot could
be the corrupted one, so there could be
more than one and, with only two parities,
we cannot say anything more.

> I think regression is going to be needed to find it. Hopefully the problem is restricted to parity computation and data chunks aren't affected; however if a URE occurs in a data chunk, it could be reconstructed incorrectly from bad parity so it's obviously still a big problem.

Maybe parities are not correctly calculated,
but I wonder how this could be, given the
amount of usage the code had and has.

Unless the new VX optimization have a problem.

bye,

-- 

piergiorgio
