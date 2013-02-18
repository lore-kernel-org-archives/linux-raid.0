From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: problems formatting raid5
Date: Mon, 18 Feb 2013 10:46:11 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302181045330.32644@uplift.swm.pp.se>
References: <1361174312.47911.YahooMailNeo@web163006.mail.bf1.yahoo.com> <alpine.DEB.2.00.1302180915080.32644@uplift.swm.pp.se> <1361176372.31472.YahooMailNeo@web163005.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1361176372.31472.YahooMailNeo@web163005.mail.bf1.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: sk <sdk0084@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 18 Feb 2013, sk wrote:

> i wait about 10 hours
> and start after the resync process completed. 
> it was not mount so i don't think there were any activity.

Well, then output from iostat -x 5 during the creation would be of 
interest. Also, try other filesystems such as xfs and see if that behaves 
differently.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
