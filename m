From: Martin Wilck <mwilck@arcor.de>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Sat, 19 Oct 2013 22:21:25 +0200
Message-ID: <5262E9C5.1050200@arcor.de>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>	<20130914203800.385466b2@notabene.brown>	<CAC9WiBh9EOFKx99fTH2yYN62A5CAg4_mqpNtxj6jZOZE+_Raww@mail.gmail.com>	<CAC9WiBja2N_Q8h6MSci+fgRWWpvvRpcMZp8FOZX3V_FK8pjhpA@mail.gmail.com>	<5234CA6A.3070305@arcor.de>	<CAC9WiBi8XyWS8AgjAE0cxiaa4uRbNS69=vfC+TKnoG_iFp2+Vg@mail.gmail.com>	<52373A19.7000105@arcor.de>	<CAC9WiBjnM5nwKf4f7UN6hQgsbYhVLLPnfAD6RATbF3C-NHRrXg@mail.gmail.com>	<523C8EF9.60809@arcor.de>	<CAC9WiBgnWHupc59z+ym2me3RcL4F6YqdE_3aXTvRN2zZZQ4jzQ@mail.gmail.com>	<CAC9WiBgzfvQkLZXT+9WYuxBUCRJqWZAvbyVmK9-9EsiwNeRxhw@mail.gmail.com>	<52409E62.3090105@arcor.de>	<CAC9WiBigzwNFV2FSU+tWS969fh+6G6ikQcrDqDyW0CbiaOuLkQ@mail.gmail.com>	<CAC9WiBje39ij9RLEqe8aha3FGn_LirxzQezXx-s5+J-HqUpwug@mail.gmail.com>	<524C6711.309080
 5@arcor.de>	<20131016155711.715678e7@notabene.brown>	<CAC9WiBiwSHTC6o2sXwjqyy78B07VCgkdJG5PpHGyYu8bNV4JvA@mail.gmail.com> <20131017215827.6a85d2bc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131017215827.6a85d2bc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Francis Moreau <francis.moro@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

>> Martin started addressing this in another new thread whose subject is
>> "RFC: incremental container assembly when sequence numbers don't
>> match"
>>
>>
> Ah yes, thanks.  I had a quick look and it seems to make sense, but it
> deserves more thorough consideration.
> I'll get on to that sometime soon.


Good that you're back. I was starting to get nervous :-)

Wrt the sequence number issue: One thing that I need to understand
better is how native MD deals with this kind of thing. Containers have
one additional complexity: one set of meta data for several subarrays.

IMO one thing I think we need is cleaner semantics for compare_super().
The return to distinguish at least the cases

  0 - OK
  1 - fatal incompatibility
  2 - nonfatal, new disk has "older" meta data
  3 - nonfatal, new disk has "newer" meta data

IMSM already has this to some extent.

The logic to handle this must be in the generic, non-metadata-specific
code. Metadata handlers need methods to force re-reading the meta data
from certain disk(s). mdmon also needs a way to detect that it needs to
reread the meta data.

Furthermore,  at least compare_super_ddf does not only compare, it also
makes changes to its internal data structures; I think other meta data
handlers do the same. IMO it would be more appropriate to do this in a
separate call, after the caller has decided if and how to merge the meta
data.

Then we need to make sure that (to the maximum extent possible) these
issued are handled similarly during Assembly and Incremental Assembly.

The "nonfatal" case is similar to the current "homehost" logic.

As for the complex scenarios in my "RFC" mail, thinking more about it, I
found that the dangerous incremental assembly cases are not so critical
after all, as long as subarrays aren't started prematurely, which is
mostly guaranteed by the current udev rules.

Regards
Martin
