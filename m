From: Sharif Islam <mislam@uiuc.edu>
Subject: Re: recreate superblock? (was Re: mdadm: failed to RUN_ARRAY)
Date: Mon, 11 Oct 2004 14:09:46 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <416ADA7A.5060802@uiuc.edu>
References: <4168064D.3050903@uiuc.edu> <4168140A.6070300@uiuc.edu>	 <416AB1E1.1070605@uiuc.edu> <1097502158.5815.62.camel@langvan2.homenetwork>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1097502158.5815.62.camel@langvan2.homenetwork>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Tran wrote:

>Hi Sharif,
>
>>From the kernel log, I believe that the raid5 array now has 4 working
>disks out of 6 raid disks.  My suggestion is to recreate the array.
>
>Before recreating the MD array, I would suggest that you run mdadm
>--examine /dev/hdxx (i.e. hde1, hdf1 or hdg1) and write down the
>information of the original array setup. 
>
>Some of the important Raid5 info are : Raid Devices, Total Devices,
>Preferred Minor (/dev/mdx), Spare Devices, Layout, Chunk Size, order of
>devices. 
>
>When you **decide** to use mdadm -C to recreate array, mdadm will ask
>you to confirm on overwriting existing md superblock.
>  
>
Thanks for your response. Will it delete the existing the data on the RAID?

-Sharif

