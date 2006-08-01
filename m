From: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: let md auto-detect 128+ raid members, fix potential race condition
Date: Tue, 01 Aug 2006 17:46:38 -0300
Message-ID: <oru04wfakx.fsf@free.oliva.athome.lsd.ic.unicamp.br>
References: <ork65veg2y.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	<20060730124139.45861b47.akpm@osdl.org>
	<orac6qerr4.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	<17613.16090.470524.736889@cse.unsw.edu.au>
	<ord5blcyg0.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	<17614.44057.322945.156592@cse.unsw.edu.au>
	<orpsflrxmb.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	<orac6p870v.fsf@free.oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <orac6p870v.fsf@free.oliva.athome.lsd.ic.unicamp.br> (Alexandre Oliva's message of "Tue, 01 Aug 2006 00:33:04 -0300")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Aug  1, 2006, Alexandre Oliva <aoliva@redhat.com> wrote:

>> I'll give it a try some time tomorrow, since I won't turn on that
>> noisy box today any more; my daughter is already asleep :-)

> But then, I could use my own desktop to test it :-)

But then, I wouldn't be testing quite the same scenario.

My boot-required RAID devices were all raid 1, whereas the larger,
separate volume group was all raid 6.

Using the mkinitrd patch that I posted before, the result was that
mdadm did try to bring up all raid devices but, because the raid456
module was not loaded in initrd, the raid devices were left inactive.

Then, when rc.sysinit tried to bring them up with mdadm -A -s, that
did nothing to the inactive devices, since they didn't have to be
assembled.  Adding --run didn't help.

My current work-around is to add raid456 to initrd, but that's ugly.
Scanning /proc/mdstat for inactive devices in rc.sysinit and doing
mdadm --run on them is feasible, but it looks ugly and error-prone.

Would it be reasonable to change mdadm so as to, erhm, disassemble ;-)
the raid devices it tried to bring up but that, for whatever reason,
it couldn't activate?  (say, missing module, not enough members,
whatever)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Secretary for FSF Latin America        http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
