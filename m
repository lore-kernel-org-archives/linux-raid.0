From: Gareth Evans <donotspam@fastmail.fm>
Subject: Re: mdadm/Software RAID problems - another update
Date: Sun, 21 Jun 2015 15:21:57 +0100
Message-ID: <1434896517.3660124.303759113.0AE76093@webmail.messagingengine.com>
References: <1434739736.4161728.300185905.45F829A7@webmail.messagingengine.com>
 <1434779786.1648537.300522273.678785B2@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1434779786.1648537.300522273.678785B2@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After a number of tests with VirtualBox this weekend, it seems things work as they should with Fedora 22 but openSUSE 13.2, Debian 8.1 and Ubuntu 14.04.2 all appear to hang on boot when one vdisk is removed and another is attached, even if formatted with a "Linux RAID autodetect"-type partition.  CentOS 7 doesn't hang but doesn't have mdadm in its emergency console (I gave up with CentOS after that as not sure how to add commands, if that's possible...) and neither Fedora nor CentOS emergency consoles seem to include fdisk, which isn't too helpful.  

I'm not sure if that helps but I thought I'd share the results of my testing - please let me know if there's anything further I can do.  This may not be an upstream bug after all - I'm not very experienced with such things but it seems to me that it is and the Fedora developers have fixed it.

With thanks
Gareth

On Sat, 20 Jun 2015, at 06:56, Gareth Evans wrote:
> I should clarify re point (2) in  my earlier email below, steps to replicate:
> 
> 1. Unencrypted RAID 10, 2 x vdi virtual drives on VirtualBox, OS installed and RAID working.
> 2. Shutdown VM and remove vdi disk2 from VirtualBox settings - boots successfully
> 3. Shutdown and attach a new blank vdi ("disk2_2") - boot fails as per (2) below
> 4. Power off and remove blank vdi disk - boot fails as per (2) below
> 5. Power off and re-attach original vdi disk2 (so the 2 originals are now attached) - boot fails as per (2) below
> 
> I wonder if I am perhaps failing to do something correctly at step 2 above, mdadm -D /dev/md1 shows disk2 as missing and mdadm --remove produces a not found error.
> 
> 
> On Fri, 19 Jun 2015, at 19:48, Gareth Evans wrote:
> > Having failed in my first attempt at setting up encrypted software RAID on Ubuntu 14.04.2, I discovered there seem to be many and various problems with software RAID on Ubuntu and Debian at least.
> > 
> > For example, I have found via testing on KVM and VirtualBox (with and on Ubuntu 14.04.2 and with Debian 8.1) that:
> > 
> > 1. Encrypted RAID doesn't boot after installation (no volume groups found, with unencrypted raided /boot)
> > 2. Degraded unencrypted RAID doesn't boot (loops on "Intermittently starting RAID arrays..." with a few lines of related output)
> > 3. /etc/initramfs-tools/conf.d/mdadm doesn't seem to exist as the Ubuntu Server Guide suggests it should
> > 4. adding bootdegraded=true to grub options at boot seems to have no effect.
> > 
> > The second point above seems particularly concerning because it would seem (unencrypted) software RAID (which works well enough while it's working) fails precisely when it is needed, which rather defeats the point.
> > 
> > I have found lots of bug reports, some still "new" and of "undecided" importance after several years, for various problems, but not many solutions. 
> > 
> > I'm not sure if the issues lie with upstream or distro-related mdadm or other packages, or perhaps kernel issues?
> > 
> > Just FYI, I did consider FreeBSD as an alternative which implements ZFS-on-Root disk pools and GELI encryption.  After limited testing this seems to work (even with only one disk if you just want to use it for encryption) but I understand ZFS can be corrupted by hardware problems (eg. faulty RAM), and FreeBSD doesn't seem to want to open LUKS containers on-the-fly, such as an encrypted external HD.  
> > 
> > I would prefer a Linux solution - any explanations, solutions, tips or advice re linux software RAID would be gratefully received.
> > 
> > With kind regards
> > Gareth
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
