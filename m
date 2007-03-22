From: dean gaudet <dean@arctic.org>
Subject: Re: XFS sunit/swidth for raid10
Date: Thu, 22 Mar 2007 01:23:06 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0703220108270.13419@twinlark.arctic.org>
References: <4601BE85.8050005@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4601BE85.8050005@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Mar 2007, Peter Rabbitson wrote:

> Hi,
> How does one determine the XFS sunit and swidth sizes for a software raid10
> with 3 copies?

mkfs.xfs uses the GET_ARRAY_INFO ioctl to get the data it needs from 
software raid and select an appropriate sunit/swidth...

although i'm not sure i agree entirely with its choice for raid10:

                *sunit = md.chunk_size >> 9;
                *swidth = *sunit * md.raid_disks;

i'd think it would depend on the layout of the raid10 (near, far, 
offset)... for near2 on 4 disks i'd expect swidth to be only 2*sunit... 
but for far2 on 4 disks i'd expect 4*sunit... but i'm not sure.  it 
probably doesn't matter.

-dean
