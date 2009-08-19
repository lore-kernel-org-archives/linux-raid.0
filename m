From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Code base for rework of ppc440SPe ADMA driver
Date: Wed, 19 Aug 2009 08:35:03 -0700
Message-ID: <e9c3a7c20908190835l37b65a2eje54a074a765e1e26@mail.gmail.com>
References: <4A8C02DC.8050308@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A8C02DC.8050308@denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 19, 2009 at 6:49 AM, Anatolij Gustschin<agust@denx.de> wrot=
e:
> Hello Dan,
>
> Currently I am trying to estimate efforts for rework of the
> ppc440SPe ADMA driver for inclusion in mainline Linux and a couple of
> questions have arisen. As the current ASYNC_TX API in mainline Linux
> doesn't contain support for RAID6 offload operations, the current
> ppc440SPe ADMA driver have to be reworked to support RAID5 operations
> only which would be a step backward and also would require some
> changes in the ASYNC_TX code to cope with large dma_addr_t addresses.
> Therefore my understanding is that the rework of the ADMA driver for
> inclusion in mainline should be better based on code from your raid6
> branch. Or what would be a better base?
>
> If I understand it correctly initially the intention was to place
> this work in linux-next and probably submit a pull request towards
> the end of the 2.6.31 merge window. Is there any plan to proceed with
> this? =A0Did you get a chance to look at per-cpu implementation for t=
he
> scribble-buffer?

Yes, this work is still progressing and I am planning a new drop of
the patches to the mailing list Real Soon Now TM.  I have just now
updated the raid6 branch [1] with the latest snapshot of the code.
You can start basing your update on this branch.  Note, it might
rebase as I receive review feedback, but I do not expect the dma
driver interface to change from this point.

This includes the percpu conversion of the scribble buffer [2], and a
new patch I am not sure about yet "multicore raid processing" [3].

--
Dan

[1]: git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git ra=
id6
[2]: http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/async_tx.git;a=3D=
commitdiff;h=3Dd02774cc58b8d80d66d49efe541afa727f6a5f15
[3]: http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/async_tx.git;a=3D=
commitdiff;h=3Da8882290f39a97ea3d16aa9bee309097d9c54abd
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
