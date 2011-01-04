From: Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: dmaengine: fix dma_unmap (was: Re: [PATCH 06/13] DMAENGINE:
 driver for the ARM PL080/PL081 PrimeCells)
Date: Tue, 4 Jan 2011 23:34:31 +0100
Message-ID: <AANLkTi=84fdEcS9EkgK-5CK0f43ZVJRHu0F6eKQpWTO6@mail.gmail.com>
References: <AANLkTinJAULeb1EsWk=S=b32h69X1x-noRw73Ok0uyfx@mail.gmail.com>
	<20110103165227.GC32508@n2100.arm.linux.org.uk>
	<AANLkTinMCLC8j=AvzaCQ+Uuyk75T=rAkaLUz0jHPOJ-d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTinMCLC8j=AvzaCQ+Uuyk75T=rAkaLUz0jHPOJ-d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>, Peter Pearse <peter.pearse@arm.com>, linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>, yuanyabin1978@sina.com, linux-arm-kernel@lists.infradead.org, Alessandro Rubini <rubini@unipv.it>
List-Id: linux-raid.ids

2011/1/3 Dan Williams <dan.j.williams@intel.com>:

> We could disable the driver if NET_DMA or ASYNC_TX_DMA are selected.
> =A0That still allows the driver to be exercised with dmatest. =A0Alth=
ough
> I notice the driver is already marked experimental, do we need
> something stronger for 37-final?

Your pick, IMHO. To use it out-of-the-box with 2.6.37 is not possible
on any system anyway - we have not patched in the required
platform data to any ARM system! Those who do such things surely
know what they're doing.

Yours,
Linus Walleij
