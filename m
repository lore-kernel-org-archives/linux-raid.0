From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 12:43:41 +0100
Message-ID: <dsftg2-8cr.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario Holbe <Mario.Holbe@tu-ilmenau.de> wrote:
> Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> > Yes, you can "sync" them by writing any one of the two mirrors to the
> > other one, and need do so only on the union of the mapped data areas,
> 
> As far as I understand the issue, this is exactly what should be
> possible.
> 
> > but it won't help you get the right data (i.e.  "yes").
> 
> There is no such thing like "the right data" from a block device's
> point of view.

Well, there is the "right data" from our point of view, and it is what
should by on (one/both?) device by now.  One doesn't get to recover that
"right data" by copying one disk over another, however efficiently one
does it.

> Both mirrors have "right data", since both got written

Well, neither do, more accurately! Not in toto, nor necesarily block by
block.

> independently. Thus, somebody has to choose one mirror being the
> "more right" one. This, of course, is in administrators hands.

But neither mirror is necessarily right.  We are already in a bad
situation.  There is no good way out.  You can merely choose which of
the two data possibilities you want for each block.  They're not
necesarily either of them "right", but one of them may be, but which one
we don't know.

> However, if somebody did so, exactly the sync you described above
> (union of the mapped data areas) must happen.

Why should one think that copying all of one disk to the other (morally)
gets one data that is more right than copying some of it? Nothing one
can do at this point will help.

Peter

