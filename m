From: Sven Luther <sven.luther@wanadoo.fr>
Subject: Re: Root Drive Mirroring and LVM.
Date: Thu, 29 Jan 2004 08:22:22 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040129072222.GB10459@iliana>
References: <868055F9-5045-11D8-8066-00039382032A@mindspring.com> <200401270801.i0R81HdT022197@kruuna.Helsinki.FI> <20040127093213.GA10049@iliana> <20040129010101.GA13800@zero>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040129010101.GA13800@zero>
To: Tom Vier <tmv@comcast.net>
Cc: Sven Luther <sven.luther@wanadoo.fr>, linuxppc-dev@lists.linuxppc.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 28, 2004 at 08:01:01PM -0500, Tom Vier wrote:
> On Tue, Jan 27, 2004 at 10:32:13AM +0100, Sven Luther wrote:
> > Seems ok for me. Also, i guess that there are other partition types,
> > like the amiga partitition table the pegasos boxes mostly use, which has
> > a 32bit identifier for partition types. I guess it is the task of the
> > RAID code to have some per partition type checking for this RAID autodetect
> > magic.
> 
> it's done in fs/partitions/. it could be made anything, as long as it's put
> in the raid docs so people know.

Ok, thanks. On amiga filesystem, partitition types are in 32bit ints,
but can also be represented as 4 chars, so maybe `RAID` would be a good
type for that ? I will try patching the kernel, and adding support in
libparted for recognizing such partitions, and try it out.

Does it make sense to do Software Raid on two partititons of the same
disk, just for testing purpose ?

> here's a patch of mine for alpha, to give you an idea.

Ok, thanks.

Friendly,

Sven Luther
