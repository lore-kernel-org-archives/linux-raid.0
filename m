From: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Subject: Re: Question about recovery via mdadm
Date: Sun, 16 Feb 2003 05:32:20 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <28330000.1045391539@shieldbreaker.l33tskillz.org>
References: <A5974D8E5F98D511BB910002A50A66470580D627@hdsmsx103.hd.intel.com> <15948.9979.534439.238616@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15948.9979.534439.238616@notabene.cse.unsw.edu.au>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>, "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-02-14 at 10:15:07+1100 Neil Brown <neilb@cse.unsw.edu.au> wrote:

> On Thursday February 13, andrew.r.cress@intel.com wrote:
> 
> > Solving why I got into this is another issue, but: Is there any
> > way, once I'm in this predicament, to force a recovery to the
> > spare, from userland (via mdadm)?
> 
> No.  Reconstrution should start automatically.  There is no
> mechanism to start it from user-space.  You could try to hot-remove
> and hot-add again, but if it didn't work the first time it is
> unlikely to work the second time.
> 
> It would appear to be a kernel bug.  Are there any kernel messages?
> An Oops or something?

I'll bet that if Andrew checks his syslog carefully, he'll find that
the mdrecovery process generated a kernel Oops:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=82815

If this is what happened, then simply rebooting the system should
cause the reconstruction to start.

> Do you know if redhat:2.4.18-14 contains any patches particular to
> md?

I doubt that's the problem, as I tried backporting the vanilla md
driver from 2.4.21-pre3 into Red Hat's kernel-2.4.18-19.8.0, and I
could still Oops it.

IMHO, the two most likely explanations are:

    1.  There's a bug in the md driver somewhere.

    2.  Red Hat has tweaked/changed something in the kernel that the
        md driver is relying on, and as a result, what the md driver
        is doing causes an Oops.

Neil, if you want to try to track this down, I'll be happy to help in
any way I can.  (I don't have enough kernel hacking experience to
track this down myself, alas.)

Regards,

-- 
James Ralston, Information Technology
Software Engineering Institute
Carnegie Mellon University, Pittsburgh, PA, USA

