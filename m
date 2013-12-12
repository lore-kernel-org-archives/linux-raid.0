From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: Using Video cards (CUDA) for RAID parity
Date: Thu, 12 Dec 2013 11:44:51 +0000
Message-ID: <52A9A1B3.5080706@mpstor.com>
References: <52A98FAF.4000205@insync.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A98FAF.4000205@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On several more RAID specific SoC (like the PowerPC 440x/460x) a XOR 
engine is included to speed up RAID calculations (effectively a hardware 
RAID engine).

I think Intel Atom CPUs were planned/got a similar engine added, but 
with the advance in CPU efficiencies and frequencies, these XOR engines 
are practically obsolete: You will barely use 5% of your CPU (if a high 
end CPU) for the parity calculation on RAID5.

These days it seems that the overhead from the parity calculations are 
so small that they become insignificant.

On the other hand this is just based from my limited experience, maybe 
there are some cases where we would benefit from that.

Regards,
Ben.

On 12/12/13 10:27, Pieter De Wit wrote:
> Hi List,
>
> Given the recent work done with techs like CUDA etc. - has the idea been
> floated to use the video card for RAID parity calculations vs the CPU ?
> Bitcoin and plenty others have shown the true speed of these cards. This
> might be a cheaper version of a RAID card.
>
> Cheers,
>
> Pieter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

