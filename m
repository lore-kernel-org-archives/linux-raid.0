From: Ed W <lists@wildgooses.com>
Subject: Re: HBA Adaptor advice
Date: Sat, 21 May 2011 10:52:30 +0100
Message-ID: <4DD78B5E.30300@wildgooses.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD5FC66.5020209@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD5FC66.5020209@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/05/2011 06:30, Stan Hoeppner wrote:
>> Are there actually any HBAs that have BBU without using their RAID
>> features?
> 
> AFAIK the LSI real RAID cards allow this.  To get them into a JBOD mode
> you have to create a single drive RAID 0 of each disk and export it.  By
> doing so the RAID firmware is actually active, though not really doing
> anything, so you get the cache and BBU benefit of the controller.  One
> of the XFS developers, Dave Chinner, posted this to the XFS list quite
> some time ago when we discussed hardware vs software RAID setups.
> 


Something I didn't consider:

When you setup most hardware raid cards to have a whole bunch of RAID0
arrays (that are then assembled as software raid), *can* I swap that
hardware raid card for a different make/model or even non raid HBA?

If I can't do this then I don't want such a card... The entire point of
avoiding hardware raid was simply to avoid the proprietory lockin...

So, to be specific, given one of the LSI/3Ware/Areca fast hardware raid
cards mentioned in this thread, and assuming that I have created a bunch
of raid0 arrays, each containing 1 drive, can anyone confirm/deny if
those single disks than then be moved to a) non raid HBA controller, b)
another hardware raid controller as a new raid0 array

I'm rather expecting that a) might be possible if the HBA can ignore the
proprietory bit and see a raw partition, but b) seems highly unlikely
since the new controller presumably wants to reformat the array in it's
own format before it will use it?

If neither are possible then there seems little advantage in using a
hardware raid as a write caching HBA card (unless the card is too
underpowered that it's a bottleneck)

Thanks

Ed W
