From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 16:24:43 +0100
Message-ID: <d1hg4d$30k$1@sea.gmane.org>
References: <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org> <dsftg2-8cr.ln1@news.it.uc3m.es> <20050319125821.GO18819@marowsky-bree.de> <hvltg2-ss8.ln1@news.it.uc3m.es> <20050319140754.GP18819@marowsky-bree.de> <lortg2-9th.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> Lars Marowsky-Bree <lmb@suse.de> wrote:
>> Split-brain is a well studied subject, and while many prevention
>> strategies exist, errors occur even in these algorithms;
> Show me how :-(.  The algorithm is perfectly simple: block, flush one,
> stop one, start one, unblock.

Sorry, but this is perfectly nonsense.
As long as you have no exactly-once semantics in distributed
environments, your simple algorithm is simply able to fail.


regards
   Mario
-- 
() Ascii Ribbon Campaign
/\ Support plain text e-mail

