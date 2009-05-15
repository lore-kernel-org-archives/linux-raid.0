From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID4 and RAID5 Code
Date: Fri, 15 May 2009 09:19:54 -0700
Message-ID: <4A0D962A.5030309@zytor.com>
References: <37d33d830905140957q6e180d89v4cd4a21d23471481@mail.gmail.com>	 <4A0D9384.1020805@zytor.com> <37d33d830905150914v5d780e44s6cc2174944530ddb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905150914v5d780e44s6cc2174944530ddb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

SandeepKsinha wrote:
>>>
>> RAID 4 is really nothing but a block layout algorithm for RAID 5 (which
>> has four more block layout algorithms.)  RAID 6 contains all five under
>> one "level".
>>
> RAID 4 vs RAID 5
> Actually debatable. They have their own pros and cons and especially
> where you don't consider the physical properties of disk.
> Addition of new disk, differences in speed of disks, etc.. create
> bottlenecks especially in case of RAID5.
> 
> Except hot spot issue with RAID 4, I find it better than all others.
> Also, most of the proprietary solutions from IBM, Adaptec and NetApp
> suggest RAID4 as compared to others.
> 
> No offenses please, this is just an opinion.
> 

I was talking referring to how the implementation works.  However, it is
still nothing but a layout policy for the same data, even though it may
have quite different performance attributes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

