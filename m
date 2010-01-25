From: berk walker <berk@panix.com>
Subject: Re: Thrashing a drive to flush out problems..
Date: Mon, 25 Jan 2010 10:02:02 -0500
Message-ID: <4B5DB26A.9070404@panix.com>
References: <77733.15823.qm@web51302.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <77733.15823.qm@web51302.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle wrote:
> Hi guys can anyone recommend a tool for thrashing the b*ll*cks of a drive in  way that isn't destructive to the data?
> 
> I was thinking badblocks with -w but it is destructive and i dont want to do anything that will potentially lower the integrity of my array? (Even tho it is raid6 :) )
> 
> There must be some bonnie esk tool that will read/write every combination to every block but keep the data safe after to flush out any sector issues etc.
> 
> Cheers.
> 
> 
> -----------------------
> N: Jon Hardcastle
> E: Jon@eHardcastle.com
> 'Do not worry about tomorrow, for tomorrow will bring worries of its own.'
> 
> ***********
> Please note, I am phasing out jd_hardcastle AT yahoo.com and replacing it with jon AT eHardcastle.com
> ***********
> 
> -----------------------
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
Thirty-some years ago, I used to use multiple instances of disk 
access/read routines.  As the areas wrapped around the last cylinder and 
restarted from zero, all lengths and frequency of seeks took place.

Of course, in those days, drives were physically huge, tracks wide and 
few.  I used to run the tests for Jaquard Systems, on occasion.  Drives 
sounded like they were gong to fly apart.  Never did find a bad one that 
way, tho-
b-

