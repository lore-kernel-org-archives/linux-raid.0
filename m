From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID10: how much does chunk size matter? Can partial chunks be written?
Date: Fri, 4 Jan 2013 18:30:25 -0700
Message-ID: <B2ADDCFE-322D-401C-AB31-DA44458AC62A@colorremedies.com>
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

> The filesystem is the "application": it's zfsonlinux. I'm putting it on
> RAID10 instead of using the disks natively because I want to encrypt it
> using LUKS, and encrypting each disk separately seemed wasteful of CPU (I
> only have 3 cores).

Also, it's worth reading this, to hopefully ensure the backup system isn't also experimental.

http://confessionsofalinuxpenguin.blogspot.com/2012/09/btrfs-vs-zfsonlinux-how-do-they-compare.html

I mean, think about it another way. You value the data, apparently, enough to encrypt it. But then you're willing to basically f around with the data by using a "nailing jello to a tree" approach for a file system. Quite honestly you should consider doing this on FreeBSD or OpenIndiana where there's native support for encryption, and for ZFS, no nail and jello required. People who care about their data, and need/want a resilient file system, do it on one of those two OSs.

If FreeBSD/OpenIndiana are no ops, the way to do it on Linux is, XFS on nearline SATA or SAS SEDs, which have an order magnitude (at least) lower UER than consumer crap, and hence less of a reason why you need to 2nd guess the disks with a resilient file system. But even though also experimental, I'd still use Btrfs before I'd use ZFS on LUKS on Linux, just saying.


Chris Murphy

