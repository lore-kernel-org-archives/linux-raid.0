From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: md extension to support booting from raid whole disks.
Date: Thu, 30 Apr 2009 08:59:35 +0200
Message-ID: <20090430065935.GD22156@boogie.lpds.sztaki.hu>
References: <1240574900.4507.2076.camel@ezra> <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com> <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com> <1240957153.18303.689.camel@ezra> <18935.35747.471257.202356@notabene.brown> <49F78F26.2040909@zytor.com> <20090429074559.GA25938@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090429074559.GA25938@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 29, 2009 at 09:45:59AM +0200, Luca Berra wrote:

> Personally I despise disk partitioning schemes, it is a concept that
> should have died long ago, even GPT, while being more sensible than PC
> partitions, is of no real use to me.  Ok on ia64 the firmware will read
> a GPT partition table and load the EFI from a partition, so yes on
> itaniums this would be the way to go, do we really care?

Just because _you_ do not use it does not mean that it is useless. Sure,
on server machines you can dedicate the whole disk for Linux and do
whatever you want. But on desktop machines dual booting is still popular
so unless you fix Windows to boot from an LVM2 volume, partitioning is
going to stay for quite some time. Virtualization helps in some cases to
get rid of the extra partition, but not always.

> I stumbled upon a lovely failure scenario that shows even your scheme is
> fragile at best.
> Due to issue i would not dwell on here the first disk was kicked from the
> raid1 containing /boot, but it was still very well readable by the bios.
> result: i took a while realizing why the hell after upgrading the kernel
> the system insisted on booting with the previous kernel ;)

This failure mode also happens exactly the same way in the "reserve some
space at the beginning ant turn it into a RAID1 without telling enyone"
scheme.

> also in your 'one sensible configuration' boot should not only be
> raid-1, but it should also be entirely contained in the portion of the
> disk accessible via int-13. i have seen distribution installers enforce
> the first constraint. not the second.

If you have such an old BIOS then you will have problems with just a
single disk as well. This has nothing to do with RAID, so I fail to see
why you bring it up.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
