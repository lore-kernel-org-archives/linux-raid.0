From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Proposed enhancements to MD
Date: Fri, 16 Jan 2004 08:11:07 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0401160808180.21098-100000@humbolt.us.dell.com>
References: <20040116140615.A24102@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040116140615.A24102@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lars Marowsky-Bree <lmb@suse.de>, Neil Brown <neilb@cse.unsw.edu.au>, Scott Long <scott_long@adaptec.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 16 Jan 2004, Christoph Hellwig wrote:
> On Fri, Jan 16, 2004 at 02:56:46PM +0100, Lars Marowsky-Bree wrote:
> > If it encodes the bus/id/lun, I can forsee bad effects if the devic=
e
> > enumeration changes because the HBAs get swapped in their slots ;-)

I believe it's just supposed to be a hint to the firmware that the driv=
e=20
has roamed from one physical slot to another.
=20
> A bus/id/lun enumeration is completely bogus.=A0 Think (S)ATA, FC or
> iSCSI.
>=20
> So is there a pointer to the current version of the spec?=A0 Just rea=
ding
> these multi-path enumerations start to give me the feeling this spec
> is designed rather badly..

www.snia.org in the DDF TWG section, but requires you be a member of SN=
IA=20
to see at present.  The DDF chairperson is trying to make the draft=20
publicly available, and if/when I see that happen I'll post a link to i=
t=20
here.

Thanks,
Matt

--=20
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
