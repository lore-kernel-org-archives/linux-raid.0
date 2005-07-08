From: Brad Campbell <brad@wasp.net.au>
Subject: Re: skip raid5 reconstruction
Date: Fri, 08 Jul 2005 22:14:01 +0400
Message-ID: <42CEC269.6010205@wasp.net.au>
References: <1120584167.5535.56.camel@localhost.localdomain>	 <42CB7E65.5010204@wasp.net.au> <1120825366.5461.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120825366.5461.14.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ming Zhang wrote:

>>I did a similar thing a while back.
>>I created the raid and waited for it to sync, I then make dd copies of the raid superblocks.
>>When I blew it up I just dd the clean superblocks back again (saved a 12 hour rebuild time)
> 
> interesting to know about this. u just check the dmesg and see where is
> the sb and then u dd it out and dd back later?

Actually, I used blockdev to get the device size and then just copied the last 64kb from memory.. 
It's a bit hazy now but that's pretty close I think

Regards
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
