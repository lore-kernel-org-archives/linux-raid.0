From: Felix Koop <fdp@fkoop.de>
Subject: Re: mdadm will only start root device degraded
Date: Sat, 12 Aug 2017 11:20:27 +0200
Message-ID: <1502529627.31985.2.camel@fkoop.de>
References: <1502092265.23002.9.camel@fkoop.de>
         <598DF0A1.5030902@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <598DF0A1.5030902@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Wol,

thanks for trying to help me.

Yes, md2 is a mirror. Initially it was a mirror of sdf1 and sdg1. Then
I broke that mirror and reassembled/recreated it as a mirror of sdf1
and cryptorootg (which is the encrypted device sdg1). After the
reassembly this worked fine until next reboot. cryprotrootg is unlocked
during boot, but md2 is not reassembled.

Is it correct that mirroring (or raid in general) does not work on
encrypted devices? If so, why?

-- 
Mit freundlichen Grüßen

Felix Koop


Am Freitag, den 11.08.2017, 19:00 +0100 schrieb Wols Lists:
> On 07/08/17 08:51, Felix Koop wrote:
> > Hello,
> > 
> > I have the following problem: /dev/md2 is my root device. This is a
> > raid1 device consisting of 2 partitions (sdg1 and sdf1). Booting in
> > this configuration worked fine.
> > 
> > When I decided to encrypt those partitions, I started to encrypt
> > one of
> > them (sdg1). Now the array always starts degraded with the
> > encrypted
> > sdg1 (cryptorootg) missing. I am asked during boot process for the
> > password and the encrypted device is unlocked successfully. But the
> > raid is not set up correctly. I have to run after every boot
> > 
> > mdadm /dev/md2 --add /dev/mapper/cryptorootg
> > 
> > and then device is sync'ing and working fine until next reboot. An
> > entry in /etc/crypttab was created.
> > 
> > What do I have to configure differently to have mdadm recognising
> > the
> > raid device correctly during boot?
> > 
> > 
> > 
> 
> Start again? I'm guessing md2 is a mirror, which means the raid code
> expects sdg1 and sdf1 to be identical. But you've now encrypted one
> of
> them, so they are not identical, which is why the raid keeps breaking
> on
> boot.
> 
> I'm out of my depth here, but if you want to encrypt your raid, you
> need
> to encrypt the raid device itself (md2), not the component devices.
> 
> (Or encrypt both component devices, such that your boot sequence will
> need to unlock them before the raid can assemble them.)
> 
> Cheers,
> Wol
