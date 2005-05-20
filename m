From: Gil <gil@fooplanet.com>
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 14:00:32 -0700
Message-ID: <428E4FF0.9010504@fooplanet.com>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com> <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com> <17029.12773.197506.463977@cse.unsw.edu.au> <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com> <17037.35615.456231.737766@cse.unsw.edu.au> <1116592212.23785.75.camel@compaq-rhel4.xsintricity.com> <428E0A92.3060108@steeleye.com> <1116611115.23785.89.camel@compaq-rhel4.xsintricity.com> <d5n1m2-rb5.ln1@news.it.uc3m.es> <428E421B.3050902@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428E421B.3050902@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: berk walker <berk@panix.com>
Cc: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

berk walker wrote:
> Peter -
> for us old folks, please expand "idempotent" in usage to reflect the
> relationships to which you refer.

In common usage, an operation is idempotent when it is provably safely
repeatable.  Another way to say it is that you can repeat an idempotent
operation without side effects.

In the context of this conversation, Peter is asking that Doug prove
that the write can be repeated on restart without corrupting the state
of the RAID array.

--Gil
