From: "H. Peter Anvin" <hpa@zytor.com>
Subject: On the subject of RAID-6 corruption recovery
Date: Thu, 27 Dec 2007 18:58:04 -0800
Message-ID: <4774663C.5090609@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I got a private email a while ago from Thiemo Nagel claiming that some 
of the conclusions in my RAID-6 paper was incorrect.  This was combined 
with a "proof" which was plain wrong, and could easily be disproven 
using basic enthropy accounting (i.e. how much information is around to 
play with.)

However, it did cause me to clarify the text portion a little bit.  In 
particular, *in practice* in may be possible to *probabilistically* 
detect multidisk corruption.  Probabilistic detection means that the 
detection is not guaranteed, but it can be taken advantage of 
opportunistically.

In particular, if you follow the algorithm of section 4 of my paper, you 
end up with a corrupt disk number, but the result is a vector, not a 
scalar.  This is because the algorithm is executed on the P* and Q* 
error vectors on a byte by byte basis.

In the common case of a single disk corruption, what you will typically 
see is an error pattern that has a consistent value interrupted by 
correct bytes (P* = Q* = {00}); this is due to bytes which still had the 
random value by chance.  For the z values which can be computed (recall, 
z is only well-defined if P* and Q* are != {00}), they should match.

There are two patterns which are likely to indicate multi-disk 
corruption and where recovery software should trip out and raise hell:

* z >= n: the computed error disk doesn't exist.

	Obviously, if "the corrupt disk" is a disk that can't exist, we
	have a bigger problem.

	This is probabilistic, since as n approaches 255, the
	probability of detection goes to zero.

* Inconsistent z numbers (or spurious P and Q references)

	If the calculation for which disk is corrupt jumps around
	within a single sector, there is likely a problem.

It's worth noting in all of this that there is 258 possible outcomes of 
the complete error analysis algorithm - 255 possible D errors (z 
values), P error, Q error, and no error.  If these are to be analyzed as 
an array, it can't be solely a byte array.

That this set is complete is shown by the fact that out of 65536 
possible (P, Q) states, this corresponds to:

1 state no error
255 states P error (the 256th state is a no-error state!)
255 states Q error
255*255 states D error (n = 255 is maximum for byte-oriented RAID-6)

... for a total of 65536 states.

	-hpa

