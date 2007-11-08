From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: telling mdadm to use spare drive.
Date: Fri, 09 Nov 2007 10:32:08 +1300
Message-ID: <47338058.4080908@sauce.co.nz>
References: <20071104170502.6db7fcb1@absurd>	<87bqa6jtxc.fsf@informatik.uni-tuebingen.de>	<20071107182602.61162e00@absurd>	<47320E4F.3070308@sauce.co.nz> <20071108212804.771c39ac@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071108212804.771c39ac@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Richard Scobie said:     (by the date of Thu, 08 Nov 2007 08:13:19 +1300)
> 
> 
>>What kernel and RAID level is this?
>>
>>If it's RAID 1, I seem to recall there was a relatively recently fixed 
>>bug for this.
> 
> 
> debian etch, stock install
> Linux 2.6.18-5-k7 #1 SMP i686 GNU/Linux
> 
> The problem was with was RAID 5.
> 
> But also I have RAID 1 there, and after --add the drives
> automatically resynced.
> 

OK.

This was the bug I was thinking of:

http://marc.info/?l=linux-raid&m=116003247912732&w=2

Regards,

Richard

