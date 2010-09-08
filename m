From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: some non critical problems... (1. mdadm segfault ->
 write-mostly, 2. smart?)
Date: Wed, 8 Sep 2010 11:44:15 +0200
Message-ID: <20100908114415.6ac8bcb9@atak.bl.pg.gda.pl>
References: <20100906143308.2e1a9291@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100906143308.2e1a9291@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Umm... to reiterate one of my questions in above email:


> md1 : active raid1 sdc1[3](W) sdb1[5](W)
>       9767416 blocks super 1.0 [2/2] [UU]
>       bitmap: 6/150 pages [24KB], 32KB chunk

Is it possible to disable that (W) --write-mostly flag? Does it
decrease performance or something, if both devices in the array are
set to (W) ?

thanks
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
