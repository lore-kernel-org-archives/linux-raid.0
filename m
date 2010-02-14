From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 19:26:54 -0200
Message-ID: <20100214212654.GC15722@khazad-dum.debian.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <20100214193406.GA15722@khazad-dum.debian.net>
 <4B786154.8090103@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B786154.8090103@shiftmail.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Michael Evans <mjevans1983@gmail.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 14 Feb 2010, Asdo wrote:
> >In my experience, every time we moved critical codepaths to userspace, we
> >ended up decreasing the *overall* system reliability.
> I don't see it like this.
> You have the same chance to screw up the system by making mistakes
> in the files in /etc, in the networking config, the firewall, the
> server applications...

Those don't require a reboot test to verify, and are far easier to rollback.

Also, they can (and SHOULD) be done on testbeds.  While the kind of screwup
where an initramfs decides to bite you hard, usually cannot (they tend to
happen when things already went horribly wrong).

> (note: I speak for Debian/Ubuntu, redhat's initramfs I think is more messy.)
> 1.x autodetection worked great for me in initramfs. Basically you
> only need /etc/mdadm/mdadm.conf copied to initramfs (via
> update-initramfs), the rest is done by Debian/Ubuntu standard
> initramfs procedure.

Yeah, cute.  What happens when the initrd is not updated for whatever
reason?  That is a new failure mode that doesn't exist with 0.9 and kernel
autorun.

It boils down to whether failure modes new to 1.x without autorun are more
likely to happen than the failure modes that are specific to 0.9 with
autorun.

IME, the 0.9 ones are less likely to happen, and I have been through quite a
few incidents involving boot problems.  Experience told me that initrds are
far more prone to operator errors than the kernel autorun.  Debian's
*stable* initramfs creators have not screwed up on me yet, but I am well
aware that they could.

> Also consider 1.x allows to choose which arrays are autoassembled
> (hostname written in the array name equal to hostname in the machine
> or specified in mdadm.conf): this is more precise than 0.9 which
> autoassembles all, I think.

That can be either a good or bad thing depending on the situation, so I
would never use it to count for (or against) 1.x or 0.9.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
