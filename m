From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Thu, 03 Feb 2005 08:39:41 -0800
Message-ID: <420253CD.9010505@zytor.com>
References: <200502031145.j13Bj1fl016074@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200502031145.j13Bj1fl016074@terminus.zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ruth Ivimey-Cook wrote:
> 
> Would you say that raid-6 is suitable for storing mission-critical data, then?
> 

What I'd say is that I don't have any evidence it's not.  Unfortunately, 
that's not quite the same thing.

> I have a .5TB raid5 array on 5 IDE disks, and given what has been said recently
> about disk MTBF's and RAID failure recovery, I'm thinking it might be best to
> switch to raid-6.
> 
> I guess such a switch is best implemented as {make backup, reformat, restore},
> if I went ahead?

Yes, right now there is no RAID5->RAID6 conversion tool that I know of.

	-hpa
