From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: some non critical problems... (1. mdadm segfault ->
 write-mostly, 2. smart?)
Date: Mon, 20 Sep 2010 13:49:38 +0200
Message-ID: <20100920134938.64382cec@atak.bl.pg.gda.pl>
References: <20100906143308.2e1a9291@atak.bl.pg.gda.pl>
	<20100908114415.6ac8bcb9@atak.bl.pg.gda.pl>
	<20100914151347.3c387cbd@atak.bl.pg.gda.pl>
	<4C94FE7B.1050009@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C94FE7B.1050009@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen said:     (by the date of Sat, 18 Sep 2010 14:01:31 -0400)

> Sorry for a late question, but in adding this to my notes, I realized I 
> wasn't clear on why this flag moved to the other partitions. Are you, 
> and if so can you clarify?

If you read my first email in this thread, you will see an excerpt
from syslog saying that mdadm segfaulted during system bootup.
I think that this is the reason, because I cannot think of any other
possible reason.

-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
