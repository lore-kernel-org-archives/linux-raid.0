From: David Brown <david.brown@hesbynett.no>
Subject: Re: Replace RAID devices without resorting to degraded mode?
Date: Thu, 13 Mar 2014 10:27:08 +0100
Message-ID: <532179EC.7070206@hesbynett.no>
References: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>	<53202503.10901@hesbynett.no>	<CAE6VuKFxqRET=tQoSvbHFd7iiKeXBPJZTBUgTTwMpzOnrPEmbg@mail.gmail.com>	<532056EB.2080206@hesbynett.no> <20140313101833.7fccbabe@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140313101833.7fccbabe@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Raul Dias <raul@dias.com.br>, Scott D'Vileskis <sdvileskis@gmail.com>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/03/14 00:18, NeilBrown wrote:
> On Wed, 12 Mar 2014 13:45:31 +0100 David Brown <david.brown@hesbynett.no>
> wrote:
> 
>> So for raid1, you would add a new mirror device, making a 3-way mirror
>> instead of a 2-way one (I don't know off-hand if md raid allows this
>> re-shape).
> 
> It sure does. raid1 can be 1-way, 2-way, 3-way, 4-way ..... and "mdadm
> --grow" can easily switch between them.
> 

I thought that was the case, but I didn't want to promise anything
without checking.

Thanks,

David



