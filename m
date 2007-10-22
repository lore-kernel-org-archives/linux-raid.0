From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: slow raid5 performance
Date: Mon, 22 Oct 2007 15:33:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710221532570.29106@p34.internal.lan>
References: <352991.69437.qm@web52803.mail.re2.yahoo.com> <471CF89D.6020104@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471CF89D.6020104@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 23 Oct 2007, Richard Scobie wrote:

> Peter wrote:
>> Thanks Justin, good to hear about some real world experience. 
>
> Hi Peter,
>
> I recently built a 3 drive RAID5 using the onboard SATA controllers on an 
> MCP55 based board and get around 115MB/s write and 141MB/s read.
>
> A fourth drive was added some time later and after growing the array and 
> filesystem (XFS), saw 160MB/s write and 178MB/s read, with the array 60% 
> full.
>
> Regards,
>
> Richard
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Yes, your chipset must be PCI-e based and not PCI.

Justin.
