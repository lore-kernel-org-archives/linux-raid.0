From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: bug in asyn_xor() function
Date: Sun, 28 Jun 2009 23:51:19 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07A31D8D@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C0534ABEC@SDCEXCHANGE01.ad.amcc.com> <4A479F5C.10208@intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <4A479F5C.10208@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the response. I see two extra arguments being passed to 
tx = dma->device_prep_dma_xor(chan, dma_dest, &dma_src[src_off],
xor_src_cnt, len, dma_flags);.
When actual function started executing it sees 2 more arguments. 

Thanks,
Marri



-----Original Message-----
From: Dan Williams [mailto:dan.j.williams@intel.com] 
Sent: Sunday, June 28, 2009 9:51 AM
To: Tirumala Reddy Marri
Cc: linux-raid@vger.kernel.org
Subject: Re: bug in asyn_xor() function

Tirumala Reddy Marri wrote:
>  
> Looks like there is bug in the do_async_xor() function where"
dma_addr_t 
> *dma_src = (dma_addr_t *) src_list;" causing corrupting source 
> addresses.  And dma_src is being modified in the for loop. This should

> be something like dma_addr_t dma_src[src_cnt].

As you can see from the comment to async_xor:

"@src_list: array of source pages (if the dest is also a source it must 
be at index zero).  The contents of this array may be overwritten."

...and the comment in async_xor_init:
/* To conserve stack space the input src_list (array of page pointers)
  * is reused to hold the array of dma addresses passed to the driver.
  * This conversion is only possible when dma_addr_t is less than the
  * the size of a pointer.  HIGHMEM64G is known to violate this
  * assumption.
  */

...this is deliberate, not ideal, but deliberate.  The reasoning is to 
avoid stack overflows for arbitrarily large arrays, so we reuse the 
input source list to perform address conversions.  This also happens in 
the non-accelerated case to perform page_address() conversions.  As a 
part of the raid6 work [1] this will be changed to a preallocated 
'scribble' buffer to preserve in the input parameters.

--
Dan

[1] git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6

I just noticed the documentation in 
Documentation/crypto/async-tx-api.txt does not reflect this 
constraint... will fix.

