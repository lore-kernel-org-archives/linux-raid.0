From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Convert RAID5 to RAID6 in a live system
Date: Wed, 23 Mar 2011 12:15:18 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1103231214010.4842@uplift.swm.pp.se>
References: <201103230843.59080.stefan.roese@gmail.com> <alpine.DEB.2.00.1103230905480.4842@uplift.swm.pp.se> <20110323131424.70a0e08a@natsu> <201103231007.48693.stefan.roese@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201103231007.48693.stefan.roese@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Roese <stefan.roese@gmail.com>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 23 Mar 2011, Stefan Roese wrote:

> Thanks. I already started with this conversion, so this 
> "--layout=preserve" is not an option for me any more. But good to know 
> that this conversion should work. But its slow - it'll take approx. 4 
> days with my 2TB drives.

Also, layout=preserve I guess would make it not a proper RAID6 but a RAID5 
with a parity disk. This is not optimal long-term.

The time you mention is normal I'd say.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
