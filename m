From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 20:33:34 +0100
Message-ID: <e1nrg2-os1.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario Holbe <Mario.Holbe@tu-ilmenau.de> wrote:
> Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> > different (legitimate) data. It doesn't seem relevant to me to consider 
> > if they are equally up to date wrt the writes they have received. They
> > will be in the wrong even if they are up to date.
> 
> The goal is to have two equal mirrors. Of course, one has to decide
> which of the both mirrors has the "main" (the surviving) data. The
> simple (past) way is to just fail one of the mirrors and add it
> again.
> To achieve the same result with bitmaps, you have to combine both
> bitmaps: Since both systems did writes to their respective mirror,
> both mirrors differ in exactly all positions where one of the both
> systems did a write (and thus marked the bitmap). So, to get the both
> mirrors back in sync, you have to consider both bitmaps, i.e. combine
> them.

Both have different data.  If you have mapped all the writes each have
ever done since they separated, all you know is (within) where they have
written that different data.  You don't know who has the right data.

Yes, you can "sync" them by writing any one of the two mirrors to the
other one, and need do so only on the union of the mapped data areas,
but it won't help you get the right data (i.e.  "yes").

The problem was in letting them both write to their respective disks in
the first place. 

Peter

