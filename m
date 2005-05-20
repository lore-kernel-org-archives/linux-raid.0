From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 23:51:20 +0200
Message-ID: <on22m2-d85.ln1@news.it.uc3m.es>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com> <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com> <17029.12773.197506.463977@cse.unsw.edu.au> <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com> <17037.35615.456231.737766@cse.unsw.edu.au> <1116592212.23785.75.camel@compaq-rhel4.xsintricity.com> <428E0A92.3060108@steeleye.com> <1116611115.23785.89.camel@compaq-rhel4.xsintricity.com> <d5n1m2-rb5.ln1@news.it.uc3m.es> <428E421B.3050902@panix.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

berk walker <berk@panix.com> wrote:
> for us old folks, please expand "idempotent" in usage to reflect the 
> relationships to which you refer.

Function f is idempotent when f.f = f. I.e. Doing it twice is the same as
doing it once.

Here the question is if you do a fraction f of a write w, and then do the
whole write w again, whether you get what you are expecting. I.e. if

     w.f = w

and f is the restriction of w to some set s, f = w|s.

Peter

