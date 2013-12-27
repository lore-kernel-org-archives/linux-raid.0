From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Fri, 27 Dec 2013 17:16:05 +0000
Message-ID: <21181.46549.590241.76206@tree.ty.sabi.co.uk>
References: <52BD8EDD.10809@assyoma.it>
	<52BD99BC.8000205@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52BD99BC.8000205@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> It does not matter (except to people writing MD-specific
>> tools).  There is nothing special as to the ordering of
>> drives or chunks on drives. Also reliability is a
>> *statistical* property not a geometric one...

[ ... ]

> 1) A1 A2 A3 A4
>    .. .. .. ..
>    A4 A1 A2 A3

> 2) A1 A2 A3 A4
>    .. .. .. ..
>    A2 A1 A4 A3

> Schema n.1 will fail on any adjacent disk failure. Eg: 1 & 2,
> 2 & 3, 3 & 4, 4 & 1. On the other hand, schema n.2 will become
> inactive only when 1 & 2 or 3 & 4 disk fail, but not, for
> example, when 2 & 3 or 1 & 4 fail.

>> That "consecutive two-disk failures" is really funny!

> [ ... ] talking about adjacent disk failures. Sorry!

The same, that the MD member devices are adjacent or not does
not matter, ordering is irrelevant.

When you compare layout 1) above and 2) above what matters is
how many 2-device failures lead to loss of data, not how many
"adjacent" 2-device failures.

RAID10 has the property that only the failure of 2 *paired* (for
the usual case of two copies of the same chunk) member devices,
whether "adjacent" or not, will lead to loss of data. So what
matters are which devices are paired, not whether they are
adjacent or not.

Using the layout convention of:

  https://www.suse.com/documentation/sles11/stor_admin/data/raidmdadmr10cpx.html#byz81ho

and doing the full picture of 4 stripes, with chunks 0, 1, 2, 3,
4, 5, 6, each replicated on 2 distinct drives out of 4:
	
1)
	a	b	c	d
	--------------------------

	0	1	2	3
	3	0	1	2

	4	5	6	7
	7	4	5	6

2)
	a	b	c	d
	--------------------------

	0	1	2	3
	1	0	3	2

	4	5	6	7
	5	4	7	6

It becomes more easily apparent that in layout 1):

  * 'a' is paired with:
    - 'b' (chunks 0 and 4);
    - 'd' (chunks 3 and 7).
  * 'c' is paired with:
    - 'b' (chunks 1 and 2);
    - 'd' (chunks 5 and 6).

while in layout 2) 'a' is paired with 'b' (chunks 0, 1, 4, 5)
and 'c' with 'd' (chunks 2, 3, 6, 7). Therefore only the failure
of 'a' and 'c' will result in no data loss. It is very easy to
swap around 'b' and 'c' an entirely equivalent layout where not
every failure of two "adjacent" devices results in data loss.

Therefore the *probability* of loss of data because of 2 member
devices failing is higher in layout 1) than layout 2), whether
or not the drives are "adjacent".

  Note that arguably layout 1) is not really RAID10, because an
  important property of RAID10 is or should be that there are
  only N/2 pairs out of N drives. Otherwise it is not quite
  'RAID1' if a chunk position in a stripe can be replicated on 2
  other devices, half the replicas on one and half on another.

That the member devices are *adjacent* is irrelevant; what
matters is the statistical chance, which is driven by the
percent of cases where 2 failures result in data loss, which
driven by the number of paired drives.
