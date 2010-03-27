From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: metadata 1.2
Date: Fri, 26 Mar 2010 18:49:25 -0700
Message-ID: <4877c76c1003261849k9219c1eq7e8ebde088b619df@mail.gmail.com>
References: <20100326194352.GA2474@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100326194352.GA2474@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 26, 2010 at 12:43 PM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi all,
>
> quick question: what's the use case for metadata 1.2?
>
> I read that the 4K offset is intended to leave space
> for the MBR and bootloader, I assume.
> The subtext here seems to be a partionless configuration
> with RAID, but I'm not aware of any bootloader which
> can boot from RAID and fit into 4K.
>
> Clarifications?
>
> Thanks a lot in advance,
>
> bye,
>
> --
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Even grub 'legacy' 0.9x can perform in the following configuration:

Several whole device in a RAID-1 units which are partitioned via some
other means internally.  Grub can map the package it needs to load in
to memory as a series of absolute block locations and embed that
information within even the normal boot-loader area, or boot-loader
area and 1/2 more sectors with ease.

This may be more difficult with raid-10 or raid-0 sets, and
considerably more difficult with raid-456 (grub would not have
redundancy at it's level of operation, but you could use an external
system and still effect data /recovery/ at which point it'd then
work...); however I see no reason it would be technically impossible,
though I don't expect it to have been a current usage consideration.

Oh, it's also possible to chainload, so the 1.2 format offers the same
benefits on partitions if you need to operate within the constraints
of other existing boot-loaders.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
