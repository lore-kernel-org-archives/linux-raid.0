From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 006 of 10] md: Set/get state of array via sysfs
Date: Thu, 1 Jun 2006 15:43:27 +1000
Message-ID: <17534.32383.326749.982364@cse.unsw.edu.au>
References: <20060601150955.27444.patches@notabene>
	<1060601051358.27613@suse.de>
	<20060601053356.GK2697@moss.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Wright on Wednesday May 31
Sender: linux-raid-owner@vger.kernel.org
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 31, chrisw@sous-sol.org wrote:
> * NeilBrown (neilb@suse.de) wrote:
> > 
> > This allows the state of an md/array to be directly controlled
> > via sysfs and adds the ability to stop and array without
> > tearing it down.
> > 
> > Array states/settings:
> > 
> >  clear
> >      No devices, no size, no level
> >      Equivalent to STOP_ARRAY ioctl
> 
> It looks like this demoted CAP_SYS_ADMIN to CAP_DAC_OVERRIDE for the
> equiv ioctl.  Intentional?

Uhm.. no.  Thanks.  I'll fix that, see if I've done similar things
elsewhere, and keep it in mind for the future.

NeilBrown
