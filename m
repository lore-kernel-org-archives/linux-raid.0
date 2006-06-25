From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Multiple raids on one machine?
Date: Sun, 25 Jun 2006 15:46:42 -0700
Message-ID: <449F1252.5090209@zytor.com>
References: <449F100D.6030509@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449F100D.6030509@cjx.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Allen wrote:
> 
> 2. Partition the raw disks into four partitions and make 
> /dev/md0,md1,md2,md3.
> But am I heading for problems here? Is there going to be a big 
> performance hit
> with four raid5 arrays on the same machine? Am I likely to have dataloss 
> problems
> if my machine crashes?
> 

2 should work just fine.

	-hpa
