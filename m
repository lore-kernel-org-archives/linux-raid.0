From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Robustness in the face of errors
Date: Sat, 16 Nov 2002 23:08:39 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15830.13639.154352.720986@notabene.cse.unsw.edu.au>
References: <20021116095649.49D701A9823@dmsd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John L. Bass on Saturday November 16
To: "John L. Bass" <jbass@dmsd.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday November 16, jbass@dmsd.com wrote:
> On first error the system currently appears to just abandon a drive, forcing
> the system into degraded mode for all I/O which follows. A much more reasonable
> approach would be to not abandon the drive completely, but rather build a fast
> lookup table with known bad blocks which would allow accesses to most areas of
> the array to continue without degradation, and only areas that have bad blocks
> would be forced into degraded mode.
> 
> Many drives will trash a sector if power drops when writing, and that sector
> will generate read errors until written. It makes sense on those drives to
> recover the data in degraded mode, and re-write followed by a verify. If the
> verify fails, and the drive support dynamic sparing/remapping the sector
> should be remapped, rewritten, and verified again. On a large 200GB arry, this
> single feature would remove nearly a day of reconstruction time for normal
> errors and sector failures, substantially improving realized reliability.
> 
> Doing dynamic error management would remove 99% of the gross software raid
> device failures I have seen over the last year.

You are largely correct...
I look forward to you providing (or sponsoring) code to do this. :-)

Maybe this should go on a FAQ as it does get mentioned from time to
time.
The answer is:
    Yes, it could be done.
    No, it hasn't been done.
    Patches are always welcome.

NeilBrown
