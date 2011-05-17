From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Incompatibility of internal bitmap with ext4 barriers?
Date: Tue, 17 May 2011 21:20:43 +0100
Message-ID: <4DD2D89B.4050700@anonymous.org.uk>
References: <BANLkTin9h+feRNWg1pWFq1t6dmBpn9keKw@mail.gmail.com>	<20110517191746.556b10fa@natsu>	<BANLkTikvZZYy9fm_sA8oAmkqim1tkbaC_A@mail.gmail.com> <20110518010020.353e5865@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110518010020.353e5865@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Jason Tinker <jsntinker@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/05/2011 20:00, Roman Mamedov wrote:
> On Tue, 17 May 2011 22:43:48 +0400
> Jason Tinker<jsntinker@gmail.com>  wrote:
>
>> Do you have RAID5 over RAID0's or an ordinary RAID5? On my box
>> ordinary RAID5 works perfectly too.
>
> Yes, I ran RAID5 of 4x2TB+(1+1TB RAID0)+(1.5+0.5TB RAID0), recently changed to
> RAID6 though, also replaced one of the RAID0s with another 2TB drive.
>
>> If your configuration is also RAID5 over RAID0 and it works fine on
>> 2.6.38 then I'll just wait for next ubuntu lts...
>
> I am not saying you should just give up. The logs you posted seem like
> they can be very helpful in tracking this down. But if it is indeed a kernel
> issue, how do you fix or even debug it it without replacing/compiling a new
> kernel, which is exactly what you do not want to do. And if you're already
> replacing a kernel, why not try a 2.6.38 right away, to check if your issue is
> already solved in there (after all 2.6.32 vs 2.6.38 are eons apart BOTH
> mdadm-wise and ext4-wise).

I've said it before and no doubt I'll say it again, but the RHEL kernels 
are often a lot closer to the most recent than their version numbers 
suggest. It's a little more difficult to tell with EL6, because Red Hat 
don't ship vanilla+patches sources any more, but their .32 series 
includes lots of backported fixes from .38 etc.

Jason, it's probably worth testing with vanilla .38 to see if that does 
fix your problem, then post to Red Hat bugzilla saying so, especially as 
it looks to me like the configuration you're trying to use ought to be a 
supported one - then a future RHEL .32 might well include the fix.

Cheers,

John.
(Not a spokesman for Red Hat, nor anyone else other than myself, and 
sometimes not even that ;-)

