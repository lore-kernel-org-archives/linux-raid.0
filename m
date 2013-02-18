From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: problems formatting raid5
Date: Mon, 18 Feb 2013 13:01:15 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302181300300.32644@uplift.swm.pp.se>
References: <1361174312.47911.YahooMailNeo@web163006.mail.bf1.yahoo.com> <alpine.DEB.2.00.1302180915080.32644@uplift.swm.pp.se> <1361176372.31472.YahooMailNeo@web163005.mail.bf1.yahoo.com> <alpine.DEB.2.00.1302181045330.32644@uplift.swm.pp.se>
 <1361184290.49903.YahooMailNeo@web163001.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1361184290.49903.YahooMailNeo@web163001.mail.bf1.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: sk <sdk0084@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 18 Feb 2013, sk wrote:

> I have tried xfs as well and it was ok. However, later it hangs several 
> times while transferring files and the only way to stop the transfer was 
> rebooting.

Then you need to start looking at your logs. Seems you have some other 
problem causing IO to stall.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
