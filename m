From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: where is async_tx_clear_ack() function called.
Date: Fri, 10 Jul 2009 10:44:31 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07B08BA9@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B08A8F@SDCEXCHANGE01.ad.amcc.com> <e9c3a7c20907101015t2396048r96be01024537df09@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <e9c3a7c20907101015t2396048r96be01024537df09@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Thanks Dan.
  I see the flags are set in the xxxx_pre_dma_xor. I am hitting  BUG_ON=
(async_tx_test_ack(depend_tx) || depend_tx->next || tx->parent) I happe=
ning. Looks like some dependency related issue.  When I suppress this b=
y calling async_tx_clear_ack() in xxx_free_slots() function, that is le=
ading to file-system corruption in the case of recovery or re-build.


The driver I am working on is a different SOC . It  is a subset of (DMA=
+XOR little different) what emccraft posted. That driver can't be used =
as it is. There is another SOC ADMA driver which is completely differen=
t HW from the emccrafts driver.


Thanks and Regards,
Marri

-----Original Message-----
=46rom: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On B=
ehalf Of Dan Williams
Sent: Friday, July 10, 2009 10:15 AM
To: Tirumala Reddy Marri
Cc: linux-raid@vger.kernel.org
Subject: Re: where is async_tx_clear_ack() function called.

On Thu, Jul 9, 2009 at 4:36 PM, Tirumala Reddy Marri<tmarri@amcc.com> w=
rote:
> Hi Dan,
> =A0 =A0While I was debugging file system crash with AMCC ADMA driver =
, I
> noticed that async_tx_clear_ack() never been called. Where is the
> async_tx->flags is cleared up on completion of DMA transfer ? Looks l=
ike
> this not cleared and I am hitting the BUG_ON() in async_tx_submit(). =
If
> I call async_tx_clear_ack() in ppc4xx_ adma_free_slots() function
> everything seems working fine .
>
> This doesn't sound normal something is going on. Somehow descriptors =
are
> allocated even though they are not free .
>

If you take a look at iop-adma.c you will see lines like:

     sw_desc->async_tx.flags =3D flags;

So we inheret the DMA_CTRL_ACK flag from when async_tx calls the
->prep routine.  It is not important to clear ack on completion, it is
only important to reset it at prep time.  It is merely a flag that
holds off recycling descriptors while the api may still want to attach
a dependency.

If memory serves correctly we have tried to debug this driver before,
please refresh my memory on how this driver is different than the one
produced by Emcraft[1] that does not seem to exhibit these problems?

Thanks,
Dan


[1]: http://patchwork.ozlabs.org/patch/18116/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
