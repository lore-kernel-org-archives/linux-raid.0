From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: Re: How safe is software RAID compared to how safe hardware RAID
	is!?
Date: Fri, 21 Nov 2003 09:02:47 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1069423366.27921.44.camel@localhost.localdomain>
References: <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
To: James R Bamford <jim@jimtreats.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We've been using software RAID for about 10 months now on our large
production database server and I have nothing but good things to say
about SW RAID.  

I believe we have one of the larger Linux software RAID arrays and it's
been great.  We've had some other hardware issues unrelated to the array
and the array has faired well.  The only thing you have to remember is
that if your machine goes down hard, your arrays will rebuild upon
reboot because they weren't marked as clean.

We also are getting MUCH better performance from SW RAID that our Dell
PERC3/QC hardware RAID cards.  Here are some numbers:

PERC3/QC single channel RAID0, 64KB chunk, ext3 ordered:
- 90MB/s sequential read

Adaptec 39160 single channel Linux SW RAID0, 64kb chunk, ext3 ord:
- 138MB/s

We are now running a 56 disk SW RAID10 array (52 disks + 4 spares) and
performance is great!

Let me know if you have any questions, but I highly recommend Linux
software RAID.

On Tue, 2003-11-18 at 18:12, James R Bamford wrote:
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
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 

Regards,
Andrew Rechenberg
Infrastructure Team, Sherman Financial Group
