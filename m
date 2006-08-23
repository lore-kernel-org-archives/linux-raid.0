From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Correct way to create multiple RAID volumes with hot-spare?
Date: Wed, 23 Aug 2006 09:17:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0608230915580.12782@chaos.egr.duke.edu>
References: <44EB5579.4020200@maine.edu> <Pine.LNX.4.64.0608230634270.15031@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0608230634270.15031@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Steve Cousins <steve.cousins@maine.edu>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 23 Aug 2006 at 6:34am, Justin Piszcz wrote

> On Tue, 22 Aug 2006, Steve Cousins wrote:
>
>> As for system information, it is (was) a Dual Opteron with CentOS 4.3 (now 
>> I'm putting FC5 on it as I write) with a 3Ware 8506-12 SATA RAID card that 
>> I am using in JBOD mode so I could do software RAID6.
>> 
>
> If you are using SW RAID, there is no 2TB limit.

Ditto for more recent HW RAIDs.  *However*, there are other considerations 
when dealing with >2TiB devices.  E.g. you can't boot from them.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
