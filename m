From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Can't add drive to array 3.3 & 3.2.3
Date: Sat, 07 Apr 2012 11:26:38 +0800
Message-ID: <4F7FB3EE.2090106@fnarfbargle.com>
References: <4F7E5309.7080302@fnarfbargle.com> <20120406202713.30ac90a3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120406202713.30ac90a3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/04/12 18:27, NeilBrown wrote:
> On Fri, 06 Apr 2012 10:20:57 +0800 Brad Campbell<lists2009@fnarfbargle.com>
> wrote:
>
>> G'day Neil,
>>
>> I've got a vanilla 3.3 kernel, and mdadm v3.2.3.
>
> Having now seen the real strace:
>
>
> Yeah, that's a bad combination when bitmaps are involved.
> mdadm v.3.2.3 has a bug with adding bitmaps.  It uses O_DIRECT writes from a
> non-aligned buffer.
>
> You could use the mdadm from my .git, and it would fix that problem, but then
> there is a kernel bug (fixed in 3.3.2 I think) which causes an oops.
>
> Probably safest to go back to mdadm-3.2.2, but going forward  to
> linux.3.3.2 and mdadm-.git would work too.

Thanks Neil,

I'll back down to 3.2.2 for now then.

Regards,
Brad

