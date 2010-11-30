From: Michele Bonera <mbonera@gmail.com>
Subject: Re: Problems after reshaping of Raid5 array
Date: Tue, 30 Nov 2010 08:23:00 +0100
Message-ID: <1291101780.15141.4.camel@bellatrix.morrisoft.local>
References: <AANLkTinUU6Mh-cYbyCF_vL2PzGzFKMcqSZmPULxctquh@mail.gmail.com>
	 <20101130084501.702e7486@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101130084501.702e7486@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il giorno mar, 30/11/2010 alle 08.45 +1100, Neil Brown ha scritto:

> > Yesterday evening I added another WD, this time an EARS
> > (512 byte sectors): I created a partition on it, respecting the

Just to be precise: 4K byte sector (my mistake).

> Yes.
> I think you can fix it by simply failing and removing sdc
> Then md/raid5 will recover that data using the parity block, and that should
> be correct.
> It appears that the partition you created on the new device started at a
> multiple of 64K.  When this happen, the superblock at the end of the
> partition also looks valid when seen at the end of the whole device.
> Somehow mdadm got confused and choose the whole device (sdc) instead of the
> partition (sdc1).

I did it and it worked! Thanks a lot Neil!!!

> I am surprised at this because since mdadm-2.5.1, mdadm will refuse to
> assemble an array if it sees two devices that appear to have the same
> superblock.  Could you possibly be using something that old??

The distribution is Ubuntu Server 10.04, 
kernel 2.6.32-26-generic-pae, mdadm 2.6.7.1

Again many thanks Neil, you saved me! :)

Cheers,
--
Michele Bonera
linux user group brescia

