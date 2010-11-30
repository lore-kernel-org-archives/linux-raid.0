From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm seems not be doing rewrites on unreadable blocks
Date: Tue, 30 Nov 2010 21:59:43 +1100
Message-ID: <20101130215943.395a7622@notabene.brown>
References: <87oc98jgqb.fsf@poker.hands.com>
	<20101130115214.0b818e48@notabene.brown>
	<AANLkTin+k_xDs0gS+NWpzdyMe5Qy7_iCL9cHpX5RmUUB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin+k_xDs0gS+NWpzdyMe5Qy7_iCL9cHpX5RmUUB@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Philip Hands <phil@hands.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 30 Nov 2010 13:40:25 +0300 CoolCold <coolthecold@gmail.com> wro=
te:

> On Tue, Nov 30, 2010 at 3:52 AM, Neil Brown <neilb@suse.de> wrote:

> > When you write 512 byte blocks to a block device, it will read a 40=
96 byte
> > block, update the 512 bytes, and write the 4096 bytes back.
> >
> >
> >>
> >> Which gives rise to this:
> >>
> >> [325487.740650] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 act=
ion 0x0
> >> [325487.740746] ata2.00: irq_stat 0x00060002, device error via D2H=
 FIS
> >> [325487.740841] ata2.00: failed command: READ DMA
> >
> > Yep. =A0read error while trying to pre-read the 4K block.
> Hmm, is true for any block device? i.e. if blockdev --getss reports
> sector size is 512 byte. Or this is related to page size?
>=20

PAGE_SIZE.


NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
