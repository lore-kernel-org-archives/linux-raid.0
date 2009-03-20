From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 	multiplication
Date: Fri, 20 Mar 2009 15:43:42 -0700
Message-ID: <49C41C1E.4060401@zytor.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>	 <49C26D91.10804@intel.com> <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759877AbZCTWoZ@vger.kernel.org>
In-Reply-To: <e9c3a7c20903191020k4d0169e3oc9749103a711f3e3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> 
> Something is broken if we take this path.  This routine could stand to
> have a WARN_ONCE(), because if it is ever called there is something is
> wrong with the raid6 offload driver.  The intent is that the
> asynchronous recovery routines will perform an early check to see if
> the recovery can be offloaded (with a series of calls to
> async_xor/async_pq).  If not we fall back to the optimized synchronous
> recovery routines (raid6_2data_recov, raid6_datap_recov).  The only
> time this path will be taken is if we have decided to perform
> asynchronous recovery but at a later call to async_pq the offload
> driver reports it has run out of descriptors.
> 

That doesn't explain what you expect the code to do.  It still doesn't 
make sense to me.

	-hpa
