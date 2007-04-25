From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Multiple disk failure, but slot numbers are corrupt and preventing
 assembly.
Date: Wed, 25 Apr 2007 18:31:11 -0400
Message-ID: <462FD6AF.3070403@tmr.com>
References: <c384c5ea0704231017i2fd01aceva845a2f61f0aae3@mail.gmail.com>	 <462CF303.6030004@dgreaves.com>	 <c384c5ea0704240004r176372e1nb384c06e558dd1f@mail.gmail.com>	 <c384c5ea0704240017m6963deet58b28b67377e8f91@mail.gmail.com>	 <462DC0B0.9010105@dgreaves.com> <c384c5ea0704240544vd15e939kdf46bd75d341f30a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c384c5ea0704240544vd15e939kdf46bd75d341f30a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leon Woestenberg wrote:
> In first instance we were searching for ways to tell mdadm what we
> know about the array (through mdadm.conf) but from all advice we got
> we have to take the 'usual' non-syncing-recreate approach.
>
> We will try to make disk clones first. Will dd suffice or do I need
> something more fancy that maybe copes with source drive read errors in
> a better fashion? 

Yes to both. dd will be fine in most cases, and I suggest using noerror 
to continue after errors, and oflag=direct just for performance. You 
could use ddrescue, it supposedly copes better with errors, although I 
don't know details.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

