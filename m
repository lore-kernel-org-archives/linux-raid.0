From: Jordan Russell <jr-list-2010@quo.to>
Subject: Re: raid1.c read_balance() LBD issue?
Date: Fri, 07 May 2010 12:37:12 -0500
Message-ID: <4BE44FC8.4010508@quo.to>
References: <4BD09399.4090901@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD09399.4090901@quo.to>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/22/2010 1:21 PM, I wrote:
> raid1.c's read_balance() function has:
> 
>         const unsigned long this_sector = r1_bio->sector;
> 
> Doesn't that need to be:
> 
>         const sector_t this_sector = r1_bio->sector;
> 
> for compatibility with LBD on 32-bit platforms?

Any comments on this?

At very least it appears the truncation to 32 bits will break the "disk
whose head is closest" logic.

-- 
Jordan Russell
