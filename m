From: Kourosh <linux-raid@mindwaresystems.com>
Subject: Re: How safe is software RAID compared to how safe hardware RAID
	is!?
Date: Tue, 18 Nov 2003 15:39:35 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1069198775.24097.6.camel@onizuka.mindwaresystems.com>
References: <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2003-11-18 at 15:12, James R Bamford wrote:
> Hi folks..
> 
> hopefully everything will be working soon and i can get on with trying to
> get some backup scripts working :)
> 
> I am going to stick with this software RAID for the near future if it
> carries on working correctly.. I was just wondering what peoples views were
> of software vs hardware raid... anything and everything really.. I'm not
> that up on all the technology... I know that 3ware have a good rep in
> hardware... I also imagine that for more exotic RAID configurations its
> obviously a help to not stress the CPU with the RAID tasks.. for me tho with
> simple mirroring the CPU costs are minimal.. the linux core is a sturdy base
> to build upon so is software raid in this way a perfectly acceptible
> reliable RAID solution..
> 
> Just curious..
> 
> Thanks for everyones help
> 
> Jim

Really depends on what you're doing and what you want out of it.  For
higher end systems with lots of I/O and very large storage needs it may
be necessary to go with a high quality hardware RAID card with a large
battery backed cache.  For smaller systems Linux does software RAID very
well, especially in these days of fast, inexpensive processors and
inexpensive memory (compared to several years ago).

One thing to consider is what happens a few years down the line and your
hardware RAID card dies.  Can you replace it?  What happens to your
data?  At least with software RAID you can replace the controller and
everything can be brought back up.

I've been using soft RAID on my own and several client servers for a few
years with no real problems.

Hope this helps.

-- 
Kourosh <linux-raid@mindwaresystems.com>

