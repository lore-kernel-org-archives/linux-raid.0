From: Gareth Evans <donotspam@fastmail.fm>
Subject: mdadm/Software RAID problems
Date: Fri, 19 Jun 2015 19:48:56 +0100
Message-ID: <1434739736.4161728.300185905.45F829A7@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Having failed in my first attempt at setting up encrypted software RAID on Ubuntu 14.04.2, I discovered there seem to be many and various problems with software RAID on Ubuntu and Debian at least.

For example, I have found via testing on KVM and VirtualBox (with and on Ubuntu 14.04.2 and with Debian 8.1) that:

1. Encrypted RAID doesn't boot after installation (no volume groups found, with unencrypted raided /boot)
2. Degraded unencrypted RAID doesn't boot (loops on "Intermittently starting RAID arrays..." with a few lines of related output)
3. /etc/initramfs-tools/conf.d/mdadm doesn't seem to exist as the Ubuntu Server Guide suggests it should
4. adding bootdegraded=true to grub options at boot seems to have no effect.

The second point above seems particularly concerning because it would seem (unencrypted) software RAID (which works well enough while it's working) fails precisely when it is needed, which rather defeats the point.

I have found lots of bug reports, some still "new" and of "undecided" importance after several years, for various problems, but not many solutions. 

I'm not sure if the issues lie with upstream or distro-related mdadm or other packages, or perhaps kernel issues?

Just FYI, I did consider FreeBSD as an alternative which implements ZFS-on-Root disk pools and GELI encryption.  After limited testing this seems to work (even with only one disk if you just want to use it for encryption) but I understand ZFS can be corrupted by hardware problems (eg. faulty RAM), and FreeBSD doesn't seem to want to open LUKS containers on-the-fly, such as an encrypted external HD.  

I would prefer a Linux solution - any explanations, solutions, tips or advice re linux software RAID would be gratefully received.

With kind regards
Gareth
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
