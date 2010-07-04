From: richard <richard@sauce.co.nz>
Subject: Re: md and sd out of sync
Date: Mon, 05 Jul 2010 11:17:54 +1200
Message-ID: <4C3116A2.7040507@sauce.co.nz>
References: <4C310A61.1020209@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C310A61.1020209@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Richard Scobie wrote:
> I have 16 x 2TB drives that each partitioned into 3 equal sized partitions.
>
> Three md RAID6 arrays have then been built, each utilising one partition
> on each drive.
>
> Over the weekend, one member of one array was failed out:

As a followup to this, when I hot removed the failed drive out, mdadm 
notified me of a failure of /dev/sdz2 (despite /dev/sdz2 no longer 
existing).

Then, some 20 minutes later, upon hot inserting the new drive, I got an 
mdadm notification of  /dev/sdz3 failing.

So it got there in the end.

Regards,

Richard
