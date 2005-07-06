From: Brad Campbell <brad@wasp.net.au>
Subject: Re: skip raid5 reconstruction
Date: Wed, 06 Jul 2005 10:47:01 +0400
Message-ID: <42CB7E65.5010204@wasp.net.au>
References: <1120584167.5535.56.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120584167.5535.56.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ming Zhang wrote:
> Hi folks
> 
> I am testing some HW performance with raid5 with 2.4.x kenrel.
> 
> It is really troublesome every time I create a raid5, wait 4 hours for
> reconstruction, and then test some data and then recreate another one
> and wait again. I wonder if there is any hack or option available to
> create a raid5 without reconstruct the parity disk. I just have interest
> to test the performance so do not care about data correctness at this
> stage.

I did a similar thing a while back.
I created the raid and waited for it to sync, I then make dd copies of the raid superblocks.
When I blew it up I just dd the clean superblocks back again (saved a 12 hour rebuild time)

Having just thought about what you wrote, I guess you are building the raid in different
configurationes each time, so my method might not be good for you.

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
