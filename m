From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] md hang at schedule in  md_write_start
Date: Tue, 10 Sep 2013 13:09:05 +0200
Message-ID: <522EFDD1.3000708@profitbricks.com>
References: <52090E6D.10104@profitbricks.com> <20130813143115.55dd27d1@notabene.brown> <5209E37D.6050107@profitbricks.com> <20130814104410.10bb2259@notabene.brown> <520B3B39.4060703@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <520B3B39.4060703@profitbricks.com>
Sender: stable-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Jack Wang <xjtuwjp@gmail.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

snip

Hi Neil,

I notice you send out pull request for md update, which include fix for
this bug.

I think we'd better include the fix to stable tree at least from 3.4
above, what do you think?

md: avoid deadlock when dirty buffers during md_stop.

> http://git.neil.brown.name/?p=md.git;a=commit;h=260fa034ef7a4ff8b73068b48ac497edd5217491

BTW: It will be great if you could add my Reported-by and Tested-by:)

Best regards,
Jack
