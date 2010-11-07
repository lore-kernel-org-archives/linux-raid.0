From: Martin Cracauer <cracauer@cons.org>
Subject: Re: Superblock V 1.2
Date: Sun, 7 Nov 2010 16:08:52 -0500
Message-ID: <20101107210852.GA77472@cons.org>
References: <20101107191507.GA31052@cons.org> <E9.7C.19545.72417DC4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E9.7C.19545.72417DC4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Martin Cracauer' <cracauer@cons.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks, Leslie,

Leslie Rhorer wrote on Sun, Nov 07, 2010 at 03:03:39PM -0600: 
> 
> > Can I read that array if I ever connect the machine to an older
> > kernel/mdadm?
> 
> 	That depends on just how old.  The new superblocks have been
> supported for quite some time.  Worst case you will need to upgrade the old
> kernel to a newer one.

Is mdadm actually involved? If I have a new enough kernel but an old
mdadm, will the kernel code alone be enough to start the array?

I guess it should since it can start the arrays at boot time with no
mdadm involved.

Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
