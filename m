From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Thu, 23 Jan 2014 19:02:21 -0600
Message-ID: <52E1BB9D.5000204@hardwarefreak.com>
References: <20140121073540.GF10140@merlins.org>	<20140121163755.GG10140@merlins.org>	<52DF7976.6070808@hardwarefreak.com>	<20140122174854.GF26014@merlins.org>	<52E051A3.3050103@hardwarefreak.com> <21217.9977.5869.747472@quad.stoffel.home>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21217.9977.5869.747472@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/23/2014 8:28 AM, John Stoffel wrote:

> But more importantly, maybe it would make sense to have this number
> automatically scale with memory size?  If you only have 1gig stay at
> 256, but then jump more aggresively to 1024, 2048, 4196 and 8192 and
> then (for now) capping at 8192.  

Setting the default based strictly on memory capacity won't work.  See
this discussion for background.

http://www.spinics.net/lists/raid/msg45364.html

-- 
Stan
