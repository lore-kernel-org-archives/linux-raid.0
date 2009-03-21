From: Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
Date: Sun, 22 Mar 2009 01:43:00 +0300
Message-ID: <49C56D74.3030303@emcraft.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <49C5486D.9020103@emcraft.com> <e9c3a7c20903211500j3f1575e7o2ad9fb5969a2bdd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20903211500j3f1575e7o2ad9fb5969a2bdd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Hi Dan,

Dan Williams wrote:
>> Have you ever tested this code path?
>>     
>
> Not this path, not yet.

You can disable the fallback to optimized synchronous functions and test
it with raid with dmaengine disabled. Or you can add support for
arbitrary coefficients in dmatest...

>   Which is exactly why I am holding back the md
> pieces.  We can collaborate on testing and stabilizing the api for a
> kernel cycle before turning on the raid6 conversion.
>   

Unfortunately we are not getting paid for this project any more so I
can't spend much time on it.

Regards, Ilya.

