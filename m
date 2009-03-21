From: Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
Date: Sun, 22 Mar 2009 01:26:36 +0300
Message-ID: <49C5699C.8050405@emcraft.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com>	 <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>	 <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com>	 <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com>	 <49C45159.8020503@zytor.com>	 <e9c3a7c20903210819r222cd4acwb466d2a11d3388f6@mail.gmail.com>	 <49C53CC0.5060303@zytor.com> <e9c3a7c20903211514p60fda2fbhc5039c16f708e81d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20903211514p60fda2fbhc5039c16f708e81d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "Sosnowski, Maciej" <maciej.sosnowski@intel.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Hi Dan,

Dan Williams wrote:
>> Why does it?  I don't see why you'd need to cover the vector-vector case
>> at all, since it doesn't appear anywhere in the algorithms.  Certainly
>> going backwards from a vector-vector set to derive if you can do a
>> scalar-vector multiply when you should have known that in the first
>> place is not really useful.
>>
>>     
>>> Looking closer, the only other caller, async_pq_zero_sum, can be
>>> deleted because it has no users.  So async_pq can become a static
>>> routine in async_r6recov.
>>>
>>>       
>> That's another issue entirely, of course :)
>>
>>     
>
> ...ah, but now I see your point and the root cause of the problem.
> The caller needs to be modified to only require scalar multiplication
> even in this corner case.
>   

Argh... There is no vector-vector multiplication at all! You just need
to swap the 'for' cycles back (as it was in the original patch by me and
Yuri) to get rid of two-dimensional lookup at each step.

Regards, Ilya.

