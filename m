From: Keld Simonsen <keld@keldix.com>
Subject: Re: How to boost performance
Date: Thu, 17 Jun 2010 22:43:27 +0200
Message-ID: <20100617204327.GA21864@rap.rap.dk>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
 <20100617100109.32a20ffa@natsu>
 <d98b7022efc6988e47f7e4114aa83f62.squirrel@www.dcsnow.com>
 <20100617221300.3e30afe0@natsu>
 <db120b2f917a2de03cbb3834ef56be7f.squirrel@www.dcsnow.com>
 <20100618020220.161c54b2@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100618020220.161c54b2@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: aragonx@dcsnow.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 18, 2010 at 02:02:20AM +0600, Roman Mamedov wrote:
> On Thu, 17 Jun 2010 15:46:05 -0400
> aragonx@dcsnow.com wrote:
> 
> > While I would agree with you if the performance was the same for reads as
> > it was writes, that is not the case here.
> 
> Reads are a massively faster operation on RAID5 than writes, in my experience
> an array easily reads at close to the theoretical limit, i.e. the speed of its
> slowest member multiplied by the member count minus one.

actually raid5 sequential reads can be faster than n-1 times the slowest disk,
as it may skip the parity blocks faster than it could read them. Not much,
probably.

raid10,f2 is theoretically the fastest of the redundancy raids for sequential reads 
as it approaches the speed of raid0, with at theoretical performance of the
number of drives times the slowest of the disks.

For more on raid performance, see https://raid.wiki.kernel.org/index.php/Performance
and for bottlenecks, see eg https://raid.wiki.kernel.org/index.php/Performance#Bottlenecks

Best regards
keld
