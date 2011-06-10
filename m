From: David Brown <david@westcontrol.com>
Subject: Re: Triple-parity raid6
Date: Fri, 10 Jun 2011 10:45:46 +0200
Message-ID: <isslla$o2i$1@dough.gmane.org>
References: <isp2g2$rf$1@dough.gmane.org>	<20110609114954.243e9e22@notabene.brown>	<isqb2o$g0s$1@dough.gmane.org>	<20110609220438.26336b27@notabene.brown> <87aadq5q1l.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87aadq5q1l.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/06/2011 05:22, Namhyung Kim wrote:
> NeilBrown<neilb@suse.de>  writes:
>> On Thu, 09 Jun 2011 13:32:59 +0200 David Brown<david@westcontrol.com>  wrote:
>>
>> You can see the current kernel code at:
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=lib/raid6;h=970c541a452d3b9983223d74b10866902f1a47c7;hb=HEAD
>>
>>
>> int.uc is the generic C code which 'unroll.awk' processes to make various
>> versions that unroll the loops different amounts to work with CPUs with
>> different numbers of registers.
>> Then there is sse1, sse2, altivec which provide the same functionality in
>> assembler which is optimised for various processors.
>>
>> And 'recov' has the smarts for doing the reverse calculation when 2 data
>> blocks, or 1 data and P are missing.
>>
>> Even if you don't feel up to implementing everything, a start might be
>> useful.  You never know when someone might jump up and offer to help.
>>
>
> Maybe I could help David to some extent. :)
>
> I'm gonna read the raid6 code next week and hope that there is a room I
> can help with, FWIW.
>

No matter how far I manage to get, I'm going to need help from someone 
who knows the system and the development process, how the new functions 
would fit with the rest of the system, and not least people who can 
check and test the code.

Making multiple parity syndromes is easy enough mathematically:

For each parity bit P_j, you have a generator g_j and calculate for d_i 
running over all data disks:

	P_j = sum((g_j ^ i) . d_i)

Raid5 parity uses g_0 = 1, so it is just the xor.
Raid6 uses g_0 = 1, g_1 = 2.

Any independent generators could be used, of course.  I am not sure how 
to prove that a set of generators is independent (except in the easy 
case of 2 generators, as shown in the raid6.pdf paper) - but brute force 
testing over all choices of dead disks is easy enough.

For Raid7, the obvious choice is g_2 = 4 - then we can re-use existing 
macros and optimisations.


I've had a brief look at int.uc - the gen_syndrome function is nice and 
small, but that's before awk gets at it.  I haven't yet tried building 
any of this, but extending raid6_int to a third syndrome is, I hope, is 
straightforward:

static void raid7_int$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
{
         u8 **dptr = (u8 **)ptrs;
         u8 *p, *q, *r;
         int d, z, z0;

         unative_t wd$$, wq$$, wp$$, w1$$, w2$$, wr$$, w3$$, w4$$;

         z0 = disks - 4;         /* Highest data disk */
         p = dptr[z0+1];         /* XOR parity */
         q = dptr[z0+2];         /* RS syndrome */
         r = dptr[z0+3];         /* RS syndrome 2 */

         for ( d = 0 ; d < bytes ; d += NSIZE*$# ) {
                 wr$$ = wq$$ = wp$$ = *(unative_t *)&dptr[z0][d+$$*NSIZE];
                 for ( z = z0-1 ; z >= 0 ; z-- ) {
                         wd$$ = *(unative_t *)&dptr[z][d+$$*NSIZE];
                         wp$$ ^= wd$$;
                         w2$$ = MASK(wq$$);
                         w1$$ = SHLBYTE(wq$$);
                         w2$$ &= NBYTES(0x1d);
                         w1$$ ^= w2$$;
                         wq$$ = w1$$ ^ wd$$;

                         w4$$ = MASK(wr$$);
                         w3$$ = SHLBYTE(wr$$);
                         w4$$ &= NBYTES(0x1d);
                         w3$$ ^= w4$$;
                         w4$$ = MASK(w3$$);
                         w3$$ = SHLBYTE(w3$$);
                         w4$$ &= NBYTES(0x1d);
                         w3$$ ^= w4$$;
                         wr$$ = w3$$ ^ wd$$;
                 }
                 *(unative_t *)&p[d+NSIZE*$$] = wp$$;
                 *(unative_t *)&q[d+NSIZE*$$] = wq$$;
                 *(unative_t *)&r[d+NSIZE*$$] = wr$$;
         }
}


I wrote the wr$$ calculations using a second set of working variables. 
I don't know (yet) what compiler options are used to generate the target 
code, nor what the awk'ed code looks like.  If the compiler can handle 
the scheduling to interlace the Q and R calculations and reduce pipeline 
delays, then that's great.  If not, then they can be manually interlaced 
if it helps the code.  But as I'm writing this blind (on a windows 
machine, no less), I don't know if it makes a difference.

As a general point regarding optimisations, is there a minimum level of 
gcc we can expect to have here?  And are there rules about compiler 
flags?  Later versions of gcc are getting very smart about 
vectorisation, and generating multiple versions of code that are 
selected automatically at run-time depending on the capabilities of the 
processor.  My hope is that the code can be greatly simplified by 
writing a single clear version in C that runs fast and takes advantage 
of the cpu, without needing to make explicit SSE, AtliVec, etc., 
versions.  Are there rules about which gcc attributes or extensions we 
can use?


Another question - what should we call this?  Raid 7?  Raid 6.3?  Raid 
7.3?  While we are in the mood for triple-parity Raid, we can easily 
extend it to quad-parity or more - the name should probably be flexible 
enough to allow that.



