From: Cry <cry_regarder@yahoo.com>
Subject: Re: Wipe failed RAID-5 disk before RMA
Date: Tue, 20 May 2008 19:28:26 +0000 (UTC)
Message-ID: <loom.20080520T192413-406@post.gmane.org>
References: <loom.20080520T190131-192@post.gmane.org> <483323FA.3000500@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 
> Cry wrote:
>> Do any of you have suggestions on how to wipe a failed raid drive before RMA
>> back to vendor/manufacturer?  I need something that keeps going when it 
>> reaches
>> a bad block.  The tool doesn't have to do multiple passes with random 
>> numbers. 
>> It shouldn't need to be nursed along.

Peter Rabbitson <rabbit+list <at> rabbit.us> writes:
> How about `badblocks -svw` ?

Nice.  I'd been using dd but that is a PIA.  Don't know why I hadn't seen
badblocks before.  I'll add when I give it a whir.:

badblocks -svw -o bad_block_list 

Thanks!

Cry

