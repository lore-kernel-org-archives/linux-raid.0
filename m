From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Wed, 02 Apr 2008 08:33:06 +1300
Message-ID: <47F28DF2.8050207@sauce.co.nz>
References: <47F020C6.1060809@tigertech.com>	<47F0281F.1070404@harddata.com>	<47F11F12.7010309@tigertech.com> <18417.16752.269484.583258@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18417.16752.269484.583258@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:

> Also putting two drives belonging to a RAID set on the same
> IDE/ATA channel is usually a bad idea for performance too.
> 

True in general, but in this case the OP has SATA drives:

http://marc.info/?l=linux-raid&m=120692062718510&w=2

Very much a guess on my part, but I would suspect the SATA support in 
the 2.6.8 kernel you are using is not helping. There was a major rewrite 
or libata error handling code in later kernels, along with significant 
other SATA and RAID improvements.

Regards,

Richard
