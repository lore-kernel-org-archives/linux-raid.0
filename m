From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 21:24:05 +0100
Message-ID: <d1fd9v$7h6$1@sea.gmane.org>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> Yes, you can "sync" them by writing any one of the two mirrors to the
> other one, and need do so only on the union of the mapped data areas,

As far as I understand the issue, this is exactly what should be
possible.

> but it won't help you get the right data (i.e.  "yes").

There is no such thing like "the right data" from a block device's
point of view. Both mirrors have "right data", since both got written
independently. Thus, somebody has to choose one mirror being the
"more right" one. This, of course, is in administrators hands.
However, if somebody did so, exactly the sync you described above
(union of the mapped data areas) must happen.


regards
   Mario
-- 
> As Luke Leighton said once on samba-ntdom, "now, what was that about
> rebooting?   that was so long ago, i had to look it up with man -k."

