From: Chris Green <cgreen@valvesoftware.com>
Subject: RE: Using Video cards (CUDA) for RAID parity
Date: Thu, 12 Dec 2013 17:30:15 +0000
Message-ID: <E38D1C1385D38045A01B28E88043427E19EE0B15@exchange10.valvesoftware.com>
References: <52A98FAF.4000205@insync.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A98FAF.4000205@insync.za.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: 'Pieter De Wit' <pieter@insync.za.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

At least for the raid5 case that would seem to be a loss performance-wise:

- AFAIK, even a single good x86 core can XOR memory at faster than the DRAM memory bandwidth of the system.
- High end GPUs have more memory bandwidth than the x86 and could perform large XOR operations between buffers at a faster rate. But the memory bandwidth over the bus to the gfx card is lower than the main memory DRAM bandwidth, so you would have a net loss from having to move the data between the GPU and CPU.


-----Original Message-----
From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Pieter De Wit
Sent: Thursday, December 12, 2013 2:28 AM
To: linux-raid@vger.kernel.org
Subject: Using Video cards (CUDA) for RAID parity

Hi List,

Given the recent work done with techs like CUDA etc. - has the idea been floated to use the video card for RAID parity calculations vs the CPU ? 
Bitcoin and plenty others have shown the true speed of these cards. This might be a cheaper version of a RAID card.

Cheers,

Pieter
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
