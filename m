From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Wipe failed RAID-5 disk before RMA
Date: Tue, 20 May 2008 21:18:18 +0200
Message-ID: <483323FA.3000500@rabbit.us>
References: <loom.20080520T190131-192@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
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

How about `badblocks -svw` ?
