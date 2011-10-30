From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: raid(1) and block caching
Date: Sun, 30 Oct 2011 12:36:47 +0000
Message-ID: <4EAD44DF.6050000@anonymous.org.uk>
References: <CAGqmV7p+GP-Ou-zUhq2rBb_9_tAEX6PRtQatvLCG9=FuOPNsow@mail.gmail.com> <20111029172641.57f92fc3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111029172641.57f92fc3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: CoolCold <coolthecold@gmail.com>
List-Id: linux-raid.ids

On 29/10/2011 07:26, NeilBrown wrote:
> On Sat, 29 Oct 2011 08:49:09 +0400 CoolCold<coolthecold@gmail.com>  wrote:
[...]
>> As there are some pros and cons on both sides (at least theoretically)
>>   I have dumb question - let's say our array md1 consists on 3 drives -
>> /dev/sd{a,b,c} - and when data read from md1 occurs, which block is
>> cached in VFS (or may be other cache in system, it would be nice to
>> know which part of system is doing caching)  - the block from md1
>> itself or from certain drive? If it is drive-based block cache, it's
>> gonna be potentially memory wasting to keep 3 similar data copies, so
>> I assume md does data reads with something like O_DIRECT flag, but as
>> I 1) don't know C 2) don't know kernel, I'm asking this on the list to
>> make this clean for myself.
>
> The kernel caches pages of files, not pages of devices.
> It doesn't matter where the page of data came from - it is the page of a file
> that is cached.

I suppose if the user was silly enough to mount the same filesystem from 
both md1 and sd{a,b,c} simultaneously then there could be duplication of 
caching, but as I say I think that'd be a silly configuration :-)

Cheers,

John.

