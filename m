From: "Michael" <michael@insulin-pumpers.org>
Subject: Re: scsi card recommendations
Date: Tue, 21 Oct 2003 12:44:51 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310211944.h9LJiq232191@bzs.org>
References: <200310210040.h9L0eR202908@bzs.org>
Reply-To: michael@insulin-pumpers.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <200310210837.43091.dusty@strike.wu-wien.ac.at>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Tuesday 21 October 2003 03:40, Michael wrote:
> > I've just inherited a couple of rack servers that have the buggy dpt
> > scsi controllers and I need to replace them with something solid.
> 
> Well, I use a dpt SCSI-Controller for some time now and luckily
> found no bugs at all. I always thought they were quite good quality.
> 
> > Recommendations for a pci scsi-3 controller would be appreciated.
> 
> I used a Mylex DAC960 and was never really fond of it. Maybe the
> AcceleRAID product line is better, but I don't know.
> 
> The RAID-company that produces to my mind the best Hardware RAID
> solutions is ICP Vortex. (Maybe they changed names now as they are
> bought by some bigger company). Anyway, they provide excellent
> quality hardware and write their Linux drivers themselves and
> contribute the code open to the Linux source tree.
> 
> The downside of ICP Vortex is that they are quite expensive.
> 
> Another thing that I would consider is software RAID. Although
> software RAID consumes far more CPU and is probably slower, to my
> mind the reliability is higher. The Linux RAID-code is thouroughly
> tested and proved to work.

I'm running software raid on everything (7 hosts), have since kernel 
2.0 but it's all IDE on individual controllers -- no scsi.

I'm just not familiar with which scsi cards are well supported now 
and don't want an orphan or one with a driver that does not work 
well. I've already managed to lock up these DPT beasts a couple of 
times on each of the servers that have them and would like very much 
to trash them soon. However, I don't want something just as bad :-(

Michael
Michael@Insulin-Pumpers.org
