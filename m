From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: raid6 check/repair
Date: Fri, 30 Nov 2007 15:42:08 +0100
Message-ID: <47502140.1080601@ph.tum.de>
References: <474431BF.30103@ph.tum.de>	<18244.64972.172685.796502@notabene.brown>	<4745B375.4030500@ph.tum.de> <18254.21949.441607.134763@notabene.brown> <474F4880.8080300@eyal.emu.id.au>
Reply-To: thiemo.nagel@ph.tum.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <474F4880.8080300@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil and Eyal,

Eyal Lebedinsky wrote:
 > Neil Brown wrote:
 >> It would seem that either you or Peter Anvin is mistaken.
 >>
 >> On page 9 of
 >> http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
 >> at the end of section 4 it says:
 >>
 >>     Finally, as a word of caution it should be noted that RAID-6 by
 >>     itself cannot even detect, never mind recover from, dual-disk
 >>     corruption. If two disks are corrupt in the same byte positions,
 >>     the above algorithm will in general introduce additional data
 >>     corruption by corrupting a third drive.
 >
 > The above a/b/c cases are not correct for raid6. While we can detect
 > 0, 1 or 2 errors, any higher number of errors will be misidentified as
 > one of these.
 >
 > The cases we will always see are:
 >     a) no  errors - nothing to do
 >     b) one error - correct it
 >     c) two errors -report? take the raid down? recalc syndromes?
 > and any other case will always appear as *one* of these (not as [c]).

I still don't agree.  I'll explain the algorithm for error handling that
I have in mind, maybe you can point out if I'm mistaken at some point.

We have n data blocks D1...Dn and two parities P (XOR) and Q
(Reed-Solomon).  I assume the existence of two functions to calculate
the parities
P = calc_P(D1, ..., Dn)
Q = calc_Q(D1, ..., Dn)
and two functions to recover a missing data block Dx using either parity
Dx = recover_P(x, D1, ..., Dx-1, Dx+1, ..., Dn, P)
Dx = recover_Q(x, D1, ..., Dx-1, Dx+1, ..., Dn, Q)

This pseudo-code should distinguish between a), b) and c) and properly
repair case b):

P' = calc_P(D1, ..., Dn);
Q' = calc_Q(D1, ..., Dn);
if (P' == P && Q' == Q) {
   /* case a): zero errors */
   return;
}
if (P' == P && Q' != Q) {
   /* case b1): Q is bad, can be fixed */
   Q = Q';
   return;
}
if (P' != P && Q' == Q) {
   /* case b2): P is bad, can be fixed */
   P = P';
   return;
}
/* both parities are bad, so we try whether the problem can
    be fixed by repairing data blocks */
for (i = 1; i <= n; n++) {
   /* assume only Di is bad, use P parity to repair */
   D' = recover_P(i, D1, ..., Di-1, Di+1, ..., Dn, P);
   /* use Q parity to check assumption */
   Q' = calc_Q(D1, ..., Di-1, D', Di+1, ..., Dn);
   if (Q == Q') {
     /* case b3): Q parity is ok, that means the assumption was
        correct and we can fix the problem */
     Di = D';
     return;
   }
}
/* case c): when we get here, we have excluded cases a) and b),
    so now we really have a problem */
report_unrecoverable_error();
return;


Concerning misidentification:  A situation can be imagined, in which two 
or more simultaneous corruptions have occurred in a very special way, so 
that case b3) is diagnosed accidentally.  While that is not impossible, 
I'd assume the probability for it to be negligible, to be compared to 
that of undetectable corruption in a RAID 5 setup.

Kind regards,

Thiemo
