From: Laurent CARON <lcaron@apartia.fr>
Subject: Re: lilo boot problems
Date: Sat, 28 Aug 2004 08:37:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41302841.5040909@apartia.fr>
References: <200408251458.46575.maarten@ultratux.net> <412F3175.1@apartia.fr> <200408280044.55286.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408280044.55286.maarten@ultratux.net>
To: linux-raid@vger.kernel.org
Cc: maarten <maarten@ultratux.net>
List-Id: linux-raid.ids

maarten wrote:

>On Friday 27 August 2004 15:04, Laurent CARON wrote:
>  
>
>>maarten wrote:
>>    
>>
>>>Hi list,
>>>
>>>I've got bitten by the recent bug(?) that lilo seems to have with 2.6.x
>>>kernels where, upon install, it prints:
>>>
>>>Fatal: Trying to map files from unnamed device 0x0000
>>>
>>>I've tried everything I could think of in lilo.conf to no avail.  Using
>>>google there are several (but not many) threads about this specific error
>>>but I've not seen a solution anywhere yet.
>>>
>>>A "raid-extra-boot" line doesn't help any, neither do any other options.
>>>
>>>At this point, I'm not even sure where the error comes from as even trying
>>>to install a normal non-raid lilo.conf now fails.
>>>      
>>>
>>you have to reconstruct your array first.
>>    
>>
>
>Eeh...  You're joking, right ?  
>  
>
As you like it.....

I had the same problem, and had to reconstruct the array first (or 
revert back to 2.4.X kernel)

-- 
Soap and education are not as sudden as a massacre, but they are more
deadly in the long run.
		-- Mark Twain

