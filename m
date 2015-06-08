From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Mon, 08 Jun 2015 21:10:26 +0100
Message-ID: <5575F6B2.6030802@youngman.org.uk>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Wieser <pwieser@trychlos.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/06/15 20:28, Pierre Wieser wrote:
> Hi all,
> 
> I currently have an almost full RAID 5 built with 4 x 2 TB disks.
> I wonder if it would be possible to migrate it to a bigger RAID 5
> with 3 x 6TB new disks.
> 
Do you have a spare (I presume SATA) disk port?

> I've imagined something like that :
> - successively fail, remove a 2TB disk, add a 4TB disk, wait for end of recovery on three 2TB disks

If you've got a spare port, the newer mdadm's have, I believe, a "clone
and replace" option. Much better than failing then rebuilding.

If not, is it worth getting a SATA expansion board? If you've not got a
specialist mobo, surely a board is only going to cost a tenner or so,
and quality isn't *that* important seeing as it's only a temporary measure.

> - at the end of this first phase, I have the same ~6TB RAID 5 clean group with 3 x 4TB + 1 x 2TB disks
> - declare the last 2 TB disk faulty and remove it
> - the RAID 5 group state goes to clean, degraded
> - grow the RAID 5 group with --size=max option
> - grow the RAID 5 group with --array-size=~12TB option
> - last, grow the RAID 5 group with --raid-devices=3 and --backup-file=... options.
> 
> And I have tested it on a small test RAID 5 group.
> As expected, this last command makes the RAID 5 group begins a reshaping operation.
> But this one keeps stucked at zero.
> 
> So I have several questions :
> 
Don't think I've answered any of them, but I might have raised new ones.
I just hope the tip saves you a bit of time.

Cheers,
Wol

