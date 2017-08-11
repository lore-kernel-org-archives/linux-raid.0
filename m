From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm will only start root device degraded
Date: Fri, 11 Aug 2017 19:00:01 +0100
Message-ID: <598DF0A1.5030902@youngman.org.uk>
References: <1502092265.23002.9.camel@fkoop.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1502092265.23002.9.camel@fkoop.de>
Sender: linux-raid-owner@vger.kernel.org
To: Felix Koop <fdp@fkoop.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/08/17 08:51, Felix Koop wrote:
> Hello,
> 
> I have the following problem: /dev/md2 is my root device. This is a
> raid1 device consisting of 2 partitions (sdg1 and sdf1). Booting in
> this configuration worked fine.
> 
> When I decided to encrypt those partitions, I started to encrypt one of
> them (sdg1). Now the array always starts degraded with the encrypted
> sdg1 (cryptorootg) missing. I am asked during boot process for the
> password and the encrypted device is unlocked successfully. But the
> raid is not set up correctly. I have to run after every boot
> 
> mdadm /dev/md2 --add /dev/mapper/cryptorootg
> 
> and then device is sync'ing and working fine until next reboot. An
> entry in /etc/crypttab was created.
> 
> What do I have to configure differently to have mdadm recognising the
> raid device correctly during boot?
> 
> 
> 
Start again? I'm guessing md2 is a mirror, which means the raid code
expects sdg1 and sdf1 to be identical. But you've now encrypted one of
them, so they are not identical, which is why the raid keeps breaking on
boot.

I'm out of my depth here, but if you want to encrypt your raid, you need
to encrypt the raid device itself (md2), not the component devices.

(Or encrypt both component devices, such that your boot sequence will
need to unlock them before the raid can assemble them.)

Cheers,
Wol
