From: Paul Kubicz <pkube@umich.edu>
Subject: Re: raid0_make_request bug: can't convert ...bigger than 8k
Date: Mon, 17 Jun 2002 09:58:00 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D0DEAE8.4070000@umich.edu>
References: <3D0A3100.9010506@umich.edu> <15629.25904.914128.956704@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks, Neil; fair enough. About what one could expect from a testing 
kernel, I guess.

I will add that the problem seemed to occur with all raids though (at 
least in my setup), not just raid0, so raiders beware...


Neil Brown wrote:

>On Friday June 14, pkube@umich.edu wrote:
>  
>
>>I'm getting a message like this when trying to compile raid into the 
>>2.5.x kernel (up to 2.5.21). I've picked up several semi-relevant 
>>messages in a search, but I couldn't find anything that directly 
>>addresses the problem.
>>    
>>
>
>That would be because the problem hasn't been addressed yet...  I'm
>afraid you will have to live without raid0 (and probably linear) in
>2.5 kernels for a while longer.
>
>NeilBrown
>  
>


