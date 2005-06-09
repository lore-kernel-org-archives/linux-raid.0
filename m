From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Is there a good reason why I can't "mdadm -Gfn1 /dev/md1" ?
Date: Thu, 9 Jun 2005 23:18:36 +1000
Message-ID: <17064.16812.95215.185952@cse.unsw.edu.au>
References: <E1DgFzi-0007K9-00@mta2.cl.cam.ac.uk>
	<17064.9218.919914.356958@cse.unsw.edu.au>
	<20050609112055.GA26006@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Thursday June 9
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 9, bluca@comedia.it wrote:
> On Thu, Jun 09, 2005 at 09:12:02PM +1000, Neil Brown wrote:
> >I'm very close to releasing mdadm 1.12.0.  It will have this fixed.
> 
> do you have a prerelease, i'd like to test the stacking stuff.

try:
  http://www.cse.unsw.edu.au/~neilb/source/mdadm/mdadm-test.tgz

It doesn't have an updated version number of anything, but it does try
to get --stop --scan right for stacked devices, and it does have
ChangeLog entries.
(I haven't done anything about improving the lot of --assemble for
stacked devices)

NeilBrown

> 
> L.
> 
> -- 
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.
>  /"\
>  \ /     ASCII RIBBON CAMPAIGN
>   X        AGAINST HTML MAIL
>  / \
