From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH 0/6] raid6check fixes
Date: Mon, 24 Jun 2013 19:10:17 +0200
Message-ID: <20130624171016.GA2237@lazy.lzy>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
 <20130619100803.03fde6d5@notabene.brown>
 <20130620161639.GA3033@lazy.lzy>
 <20130624170458.568dafcb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130624170458.568dafcb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 24, 2013 at 05:04:58PM +1000, NeilBrown wrote:
[...]
> > Hi Neil,
> > 
> > BTW, what's your plan of including "raid6check"
> > into a main release of "mdadm" package?
> > 
> > Do you have "deadline" in mind?
> 
> What exactly do you mean by that?
> raid6check.c is already in the upstream git tree and was in mdadm-3.2.5.

Hi Neil, I was under the impression you were
holding back the patches from Robert (Buchholz).

Probably I was wrong.
 
> Do you mean when will it be included by distros?  That is really up to them.
> I could get "make install" to install it I guess.
> I haven't really thought about what would be required for that.
> 
> I'll add it to my list of things to think about.

Well, that could be some thinking for 3.3, couldn't it? :-)

In any case, yes, it would be nice to force a bit
the hand of the distros by installing "raid6check" too.

Thanks,

bye,

pg

> NeilBrown
> 
> > 
> > Thanks,
> > 
> > bye,
> > 
> 



-- 

piergiorgio
