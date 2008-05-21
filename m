From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Wipe failed RAID-5 disk before RMA
Date: Wed, 21 May 2008 12:07:45 -0400
Message-ID: <483448D1.9050808@tmr.com>
References: <loom.20080520T190131-192@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20080520T190131-192@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cry <cry_regarder@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cry wrote:
> Folks,
>
> Do any of you have suggestions on how to wipe a failed raid drive before RMA
> back to vendor/manufacturer?  I need something that keeps going when it reaches
> a bad block.  The tool doesn't have to do multiple passes with random numbers. 
> It shouldn't need to be nursed along.
>   

dban.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


