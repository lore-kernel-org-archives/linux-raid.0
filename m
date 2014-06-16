From: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Mon, 16 Jun 2014 17:14:30 +0100
Message-ID: <CADqA9ubBicDLwrdgOYNT04P0SO8pi+FK-ipjONY+59ThV0zGKw@mail.gmail.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
 <539E5504.1080809@turmel.org> <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
 <539EFF1C.3000009@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <539EFF1C.3000009@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the tips.

On Mon, Jun 16, 2014 at 3:28 PM, Phil Turmel <philip@turmel.org> wrote:
> Modern consumer-grade drives that have it are listed as "NAS" duty
> drives.

Marketing... The one that is taking the lead is WD Red WD10EFRX. Can't
find the Toshiba DT01ACA100 at an affordable price anymore and Seagate
is everywhere.
Back to a previous question (assuming i have the drives sorted out first):

If i create a RAID10 with 3 1TB drives, with --layout=f2, would this
give me 2TB of space +1TB redundancy? Is this a 1E?
Using: mdadm --create /dev/md0 --verbose --chunk=128 --level=10
--layout=f2 --raid-devices=3 /dev/sd[abd]1

If so, what would be the difference to a RAID5:
mdadm --create /dev/md0 --verbose --chunk=512 --level=5
--raid-devices=3 /dev/sd[abd]1

Besides one having redundancy and the other having parity; and that
RAID5 must compute parity (is that really so horrendously slow
nowadays?).

Other than tiobench, any other benchmarking tools you guys recommend?
(I've decided to just go slow and test every layer out before moving
to the next, i.e. 1st RAID, LVM, FSs, Xen, apps.)
