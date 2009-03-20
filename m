From: Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
Date: Sat, 21 Mar 2009 02:00:42 +0300
Message-ID: <49C4201A.5060905@emcraft.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com> <49C41C1E.4060401@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757155AbZCTXBW@vger.kernel.org>
In-Reply-To: <49C41C1E.4060401@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Hi H. Peter,

H. Peter Anvin wrote:
>> Something is broken if we take this path.  This routine could stand to
>> have a WARN_ONCE(), because if it is ever called there is something is
>> wrong with the raid6 offload driver.  The intent is that the
>> asynchronous recovery routines will perform an early check to see if
>> the recovery can be offloaded (with a series of calls to
>> async_xor/async_pq).  If not we fall back to the optimized synchronous
>> recovery routines (raid6_2data_recov, raid6_datap_recov).  The only
>> time this path will be taken is if we have decided to perform
>> asynchronous recovery but at a later call to async_pq the offload
>> driver reports it has run out of descriptors.
>>
>
> That doesn't explain what you expect the code to do.  It still doesn't
> make sense to me.

We defined async_pq() function as hardware can do GF multiplication of
arbitrary elements and we want to take advantage of this fact. But by
the design of ASYNC_TX API we have to provide synchronous version of
that function too.

Regards, Ilya.
