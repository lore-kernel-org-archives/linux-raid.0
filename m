From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: filesystem corruption with RAID6.
Date: Fri, 03 Sep 2004 14:16:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4138DF2D.5040505@zytor.com>
References: <wxx7jrbo87d.fsf@nommo.uio.no> <20040903170627.GA11021@jim.sh>	<4138B5A6.7070304@zytor.com> <wxxr7pjumhh.fsf@nommo.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wxxr7pjumhh.fsf@nommo.uio.no>
To: Terje Kvernes <terjekv@math.uio.no>
Cc: Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Terje Kvernes wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>   [ ... ]
> 
> 
>>Note: the corruption Jim found and which I have confirmed are only
>>when doing large number of writes to a filesystem in degraded mode.
>>If you see something different, please let me know.  It would
>>definitely help tracking this down.
> 
> 
>   ah!  that explains it then.  I was indeed copying over data in
>   degraded mode.
>    
> 
>>The bug is elusive enough that it's difficult :-/
> 
>   ouch.  and RAID that can't be written to in degraded mode is
>   somewhat impractical for production use.  ;-)
>  
>   is there anything I can do to help?  otherwise, I'll fall back to
>   RAID5 and prepare the box for production.
> 

Unless you want to try to help hunt down the bug, not much.

	-hpa

