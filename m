From: Dan Williams <dan.j.williams@intel.com>
Subject: dmaengine: fix dma_unmap (was: Re: [PATCH 06/13] DMAENGINE: driver
 for the ARM PL080/PL081 PrimeCells)
Date: Mon, 3 Jan 2011 08:36:00 -0800
Message-ID: <AANLkTinJAULeb1EsWk=S=b32h69X1x-noRw73Ok0uyfx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>, yuanyabin1978@sina.com, linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>, linux-arm-kernel@lists.infradead.org, Alessandro Rubini <rubini@unipv.it>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 3, 2011 at 3:14 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Jan 02, 2011 at 09:33:34PM +0100, Linus Walleij wrote:
>> As for the in-tree PL08x driver I'd say it's doing pretty well for
>> memcpy() so we could add platform data for that on supported
>> platforms, then for device transfers we need more elaborative
>> work.
>
> It has the issue that it's not unmapping the buffers after the memcpy=
()
> operation has completed, so on ARMv6+ we have the possibility for
> speculative prefetches to corrupt the destination buffer.
>
> Neither are a number of the other DMA engine drivers. =A0This is why =
I'd
> like to see some common infrastructure in the DMA engine core for say=
ing
> "this tx descriptor is now complete" so that DMA engine driver author=
s
> don't have to even think about whether they should be unmapping buffe=
rs.

This requires that a copy of the mapped addresses be maintained
outside the driver's physical descriptor.  This needs support from the
client to set up storage for this information (probably a
scatterlist).  The dmaengine core could use this to implement a common
unmap routine.  However,  this still has the problem of how to prevent
unmapping too early in the multi-operation raid case and how to
communicate the full set of addresses to unmap to the final descriptor
in such a chain.  I think the only way to fully solve this is to make
the client solely responsible for both mapping and unmapping.

=46or raid this will have implications for architectures that split
operation types on to different physical channels.  Preparing the
entire operation chain ahead of time is not possible on such
configuration because we need to remap the buffers for each channel
transition.  So, raid will have an optimized path for engines like
mv_xor, ioatdma, and iop-adma (iop13xx) where all buffers can be
mapped upfront (against a single physical channel) and then unmapped
when all stripe operations complete.  For the others iop-adma (iop3xx)
and ppc44x we need to wait for each leg to finish before mapping and
issuing the next leg.  There will most likely be negative performance
implications of waiting and reissuing, but as far as I can see this is
unavoidable.

> I'd also like to see DMA_COMPL_SKIP_*_UNMAP always set by prep_slave_=
sg()
> in tx->flags so we don't have to end up with "is this a slave operati=
on"
> tests in the completion handler.

Longer term I do not see these flags surviving, but yes a 2.6.38
change along these lines makes sense.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
