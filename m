From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: DMA zeroing destination and zero_sum support
Date: Fri, 24 Jul 2009 10:43:01 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7CED5@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07BC569D@SDCEXCHANGE01.ad.amcc.com> <AC5E1C3367E37D44970B81A6ADD1DA2C07BC582C@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07BC582C@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

BTW after enabled zeroing the destination when ASYNC_TX_XOR_ZERO_DST is
set solved my file-system corruption problem. But this seem to affect my
performance though.

Thanks,
Marri

-----Original Message-----
From: Tirumala Reddy Marri 
Sent: Tuesday, July 21, 2009 10:47 AM
To: Tirumala Reddy Marri; linux-raid@vger.kernel.org
Subject: RE: DMA zeroing destination and zero_sum support

Looks like do_async_xor assumes destination will be zeroed
automatically. Whereas sync_xor does the zeroing of destination if it is
not one of the sources. 




-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tirumala Reddy
Marri
Sent: Monday, July 20, 2009 3:11 PM
To: linux-raid@vger.kernel.org
Subject: DMA zeroing destination and zero_sum support

Hi Dan,
   There may be an issue when ADMA doesn't support
xxxx_prep_dma_zero_sum() support    OR  not setting destinations to zero
(ASYNC_TX_XOR_ZERO_DST) . Could you please comment on what are issues on
not zeroing dest when ASYNC_TX_XOR_ZERO_DST is set.
Thanks,
Marri
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
