From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: filesystem corruption with RAID6.
Date: Sat, 04 Sep 2004 20:01:44 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <413A8198.8060805@zytor.com>
References: <wxx7jrbo87d.fsf@nommo.uio.no> <20040903170627.GA11021@jim.sh>	<4138B5A6.7070304@zytor.com> <wxxr7pjumhh.fsf@nommo.uio.no>	<4138DF2D.5040505@zytor.com> <wxx7jr9veoa.fsf@nommo.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wxx7jr9veoa.fsf@nommo.uio.no>
To: Terje Kvernes <terjekv@math.uio.no>
Cc: Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Terje Kvernes wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
> 
>>Terje Kvernes wrote:
>>
>>
>>>ouch.  and RAID that can't be written to in degraded mode is
>>>somewhat impractical for production use.  ;-) is there anything I
>>>can do to help?  otherwise, I'll fall back to RAID5 and prepare
>>>the box for production.
>>
>>Unless you want to try to help hunt down the bug, not much.
> 
> 
>   hm, so how do I help?  :-)
> 

Dig into the code and try to figure out what is happening.  My best 
guess at this point is that a block which is dirty isn't getting marked 
as such, and therefore isn't getting correctly written back, but it 
could also be that it tries to reconstruct a block before it actually 
has all the blocks that it needs to do the reconstruction correctly.

	-hpa
