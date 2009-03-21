From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF
	multiplication
Date: Sat, 21 Mar 2009 15:53:38 -0700
Message-ID: <e9c3a7c20903211553w5200ea0cu360d0a57fef77c66@mail.gmail.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
	 <49C26D91.10804@intel.com> <49C5486D.9020103@emcraft.com>
	 <e9c3a7c20903211500j3f1575e7o2ad9fb5969a2bdd@mail.gmail.com>
	 <49C56D74.3030303@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49C56D74.3030303@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

On Sat, Mar 21, 2009 at 3:43 PM, Ilya Yanok <yanok@emcraft.com> wrote:
> Hi Dan,
>
> Dan Williams wrote:
>>> Have you ever tested this code path?
>>>
>>
>> Not this path, not yet.
>
> You can disable the fallback to optimized synchronous functions and t=
est
> it with raid with dmaengine disabled. Or you can add support for
> arbitrary coefficients in dmatest...

There are also corner cases with channel switching that can only be
tested with an async_tx specific test module and coordination from the
driver.

>> =A0 Which is exactly why I am holding back the md
>> pieces. =A0We can collaborate on testing and stabilizing the api for=
 a
>> kernel cycle before turning on the raid6 conversion.
>>
>
> Unfortunately we are not getting paid for this project any more so I
> can't spend much time on it.

Hopefully I can occasionally call on you to try out some tests with
ppc440spe driver and hardware?  As we have seen in the past that
platform hits corner cases that iop13xx does not.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
