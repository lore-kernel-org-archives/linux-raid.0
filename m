From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 20:01:53 +0100
Message-ID: <d1f8fr$k8f$1@sea.gmane.org>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> Paul Clements <paul.clements@steeleye.com> wrote:
>> The solution is to combine the bitmaps and resync in one direction or 
>> the other. Otherwise, you've got to do a full resync...
> I don't see that this solves anything. If you had both sides going at
> once, receiving different writes, then you are sc&**ed, and no
> resolution of bitmaps will help you, since both sides have received

Paul's way will.

> different (legitimate) data. It doesn't seem relevant to me to consider 
> if they are equally up to date wrt the writes they have received. They
> will be in the wrong even if they are up to date.

The goal is to have two equal mirrors. Of course, one has to decide
which of the both mirrors has the "main" (the surviving) data. The
simple (past) way is to just fail one of the mirrors and add it
again.
To achieve the same result with bitmaps, you have to combine both
bitmaps: Since both systems did writes to their respective mirror,
both mirrors differ in exactly all positions where one of the both
systems did a write (and thus marked the bitmap). So, to get the both
mirrors back in sync, you have to consider both bitmaps, i.e. combine
them.


regards
   Mario
-- 
I heard, if you play a NT-CD backwards, you get satanic messages...
That's nothing. If you play it forwards, it installs NT.

