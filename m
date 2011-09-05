From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Mon, 05 Sep 2011 12:47:16 +0200
Message-ID: <4E64A8B4.7040107@macroscoop.nl>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl> <4E5FAFE9.3040604@macroscoop.nl> <4E5FB762.4050003@yuiop.co.uk> <4E5FBF08.5080709@macroscoop.nl> <4E609B8A.9030401@macroscoop.nl> <alpine.DEB.2.00.1109021232330.13538@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1109021232330.13538@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: John Robinson <john.robinson@yuiop.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/02/2011 12:33 PM, Mikael Abrahamsson wrote:
> So yes, go for the whole device approach. I would make sure the 
> partition table is wiped and that I was using v1.2 superblocks 
> (default by now). 

Could I have both? That is, add the whole device to the array, yet have 
a protective
partition table?

I like the idea of having a protective partition table, similar to the 
EE type that protects GPT
partitions from non-GPT aware partitioning software or OS's.

It looks like the 1.2 superblock allows just that, as it starts 4k past 
the start.

So, would it be wise to add the whole device to an array, using 1.2 
metadata,
with a fake partition table (type DA) ?

Thanks,
Pim
