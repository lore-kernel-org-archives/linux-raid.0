From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 16:58:30 +0100
Message-ID: <6qutg2-cel.ln1@news.it.uc3m.es>
References: <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org> <dsftg2-8cr.ln1@news.it.uc3m.es> <20050319125821.GO18819@marowsky-bree.de> <hvltg2-ss8.ln1@news.it.uc3m.es> <20050319140754.GP18819@marowsky-bree.de> <lortg2-9th.ln1@news.it.uc3m.es> <d1hg4d$30k$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario Holbe <Mario.Holbe@tu-ilmenau.de> wrote:
> Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> > Lars Marowsky-Bree <lmb@suse.de> wrote:
> >> Split-brain is a well studied subject, and while many prevention
> >> strategies exist, errors occur even in these algorithms;
> > Show me how :-(.  The algorithm is perfectly simple: block, flush one,
> > stop one, start one, unblock.
> 
> Sorry, but this is perfectly nonsense.
> As long as you have no exactly-once semantics in distributed
> environments, your simple algorithm is simply able to fail.

You DO have "exactly once" semantics. Writes go to the ONE place that
is live. Notice that in my algorithm there are no two live things at
once.

Peter

