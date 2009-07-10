From: Dan Williams <dan.j.williams@intel.com>
Subject: RE: where is async_tx_clear_ack() function called.
Date: Fri, 10 Jul 2009 10:53:36 -0700
Message-ID: <1247248416.15724.5.camel@dwillia2-linux.ch.intel.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B08A8F@SDCEXCHANGE01.ad.amcc.com>
	 <e9c3a7c20907101015t2396048r96be01024537df09@mail.gmail.com>
	 <AC5E1C3367E37D44970B81A6ADD1DA2C07B08BA9@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07B08BA9@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 2009-07-10 at 10:44 -0700, Tirumala Reddy Marri wrote:
> 
> Thanks Dan.
>   I see the flags are set in the xxxx_pre_dma_xor. I am hitting
> BUG_ON(async_tx_test_ack(depend_tx) || depend_tx->next || tx->parent)
> I happening. Looks like some dependency related issue.  When I
> suppress this by calling async_tx_clear_ack() in xxx_free_slots()
> function, that is leading to file-system corruption in the case of
> recovery or re-build.
> 
> 
> The driver I am working on is a different SOC . It  is a subset of
> (DMA+XOR little different) what emccraft posted. That driver can't be
> used as it is. There is another SOC ADMA driver which is completely
> different HW from the emccrafts driver.

Channel switching can be tricky to debug.  One thing you might try is
limiting offload to one channel.  I.e. if memcpy and xor are provided by
different channels then turn off (don't register) the memcpy channels
and see if that resolves your issue.  If it does then you need to review
the iop-adma driver or the Emcraft ppc440spe driver to see what is
causing the mishandling of channel switching.

--
Dan


