From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID10: how much does chunk size matter? Can partial chunks be written?
Date: Fri, 4 Jan 2013 17:27:10 -0700
Message-ID: <61F2A00E-00D2-47BE-ACF3-9740DAB0F6DE@colorremedies.com>
References: <20130104175458.GA3298@hellgate> <50E75CE2.8060105@hardwarefreak.com> <20130104234113.GA14799@hellgate>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130104234113.GA14799@hellgate>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 4, 2013, at 4:41 PM, Andras Korn <korn@raidlist.elan.rulez.org> wrote:
> 
> The filesystem is the "application": it's zfsonlinux. I'm putting it on
> RAID10 instead of using the disks natively because I want to encrypt it
> using LUKS, and encrypting each disk separately seemed wasteful of CPU (I
> only have 3 cores).
> 
> I realize that I forsake some of the advantages of zfs by putting it on an
> mdraid array.

I would not do this, you eliminate not just some of the advantages, but all of the major ones including self-healing. Your choices are:

dmcrypt/LUKS (ZFS on encrypted logical device)
ecryptfs (encrypted fs on top of ZFS)
Nearline (or enterprise) drives that have self-encryption

The only way ZFS can self-heal is if it directly manages its own mirrored copies or its own parity. To use ZFS in the fashion you're suggesting I think is pointless, so skip using md or LVM. And consider the list in reverse order as best performing, with your idea off the list entirely.

Three cores? Does it have AES-NI? If it does, it adds maybe 2% overhead for encryption, although I can't tell if you off hand if that's per disk.


Chris Murphy

