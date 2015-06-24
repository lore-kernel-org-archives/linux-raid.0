From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm/Software RAID problems
Date: Thu, 25 Jun 2015 09:21:32 +1000
Message-ID: <20150625092132.5791ab5f@noble>
References: <1434739736.4161728.300185905.45F829A7@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1434739736.4161728.300185905.45F829A7@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gareth Evans <donotspam@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 19 Jun 2015 19:48:56 +0100 Gareth Evans <donotspam@fastmail.fm>
wrote:

> Having failed in my first attempt at setting up encrypted software RAID on Ubuntu 14.04.2, I discovered there seem to be many and various problems with software RAID on Ubuntu and Debian at least.
> 
> For example, I have found via testing on KVM and VirtualBox (with and on Ubuntu 14.04.2 and with Debian 8.1) that:
> 
> 1. Encrypted RAID doesn't boot after installation (no volume groups found, with unencrypted raided /boot)
> 2. Degraded unencrypted RAID doesn't boot (loops on "Intermittently starting RAID arrays..." with a few lines of related output)
> 3. /etc/initramfs-tools/conf.d/mdadm doesn't seem to exist as the Ubuntu Server Guide suggests it should
> 4. adding bootdegraded=true to grub options at boot seems to have no effect.
> 
> The second point above seems particularly concerning because it would seem (unencrypted) software RAID (which works well enough while it's working) fails precisely when it is needed, which rather defeats the point.
> 
> I have found lots of bug reports, some still "new" and of "undecided" importance after several years, for various problems, but not many solutions. 
> 
> I'm not sure if the issues lie with upstream or distro-related mdadm or other packages, or perhaps kernel issues?

Most of the issues you identify lie on the overlap between mdadm and
the boot loader - mkinitramfs or dracut or whatever.
It is distro problem to make these work together.  As upstream md and
mdadm maintainer I'm happy to work with distro maintainer to resolve
issues.  I can tell you how I think it should work and discuss how it
can work, but I am not in a position to diagnose exactly what is
happening and figure out what to fix.

You really need to follow this up with Debian, though unfortunately I
think the current Debian mdadm maintainer is not able to put in as much
time as he would like.

NeilBrown


> 
> Just FYI, I did consider FreeBSD as an alternative which implements ZFS-on-Root disk pools and GELI encryption.  After limited testing this seems to work (even with only one disk if you just want to use it for encryption) but I understand ZFS can be corrupted by hardware problems (eg. faulty RAM), and FreeBSD doesn't seem to want to open LUKS containers on-the-fly, such as an encrypted external HD.  
> 
> I would prefer a Linux solution - any explanations, solutions, tips or advice re linux software RAID would be gratefully received.
> 
> With kind regards
> Gareth
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in

