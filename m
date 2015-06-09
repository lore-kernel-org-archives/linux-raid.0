From: Pierre Wieser <pwieser@trychlos.org>
Subject: Re: Migrating a RAID 5 from 4x2TB to 3x6TB ?
Date: Tue, 9 Jun 2015 20:33:13 +0200 (CEST)
Message-ID: <1411740775.992.1433874793687.JavaMail.zimbra@wieser.fr>
References: <167089395.613.1433791723592.JavaMail.zimbra@wieser.fr> <5575F6B2.6030802@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5575F6B2.6030802@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

----- Original Message -----
> On 08/06/15 20:28, Pierre Wieser wrote:
> > Hi all,
> > 
> > I currently have an almost full RAID 5 built with 4 x 2 TB disks.
> > I wonder if it would be possible to migrate it to a bigger RAID 5
> > with 3 x 6TB new disks.
> > 
> Do you have a spare (I presume SATA) disk port?

I am away from home this evening, but, no, I do not "see" any free sata port.

> > I've imagined something like that :
> > - successively fail, remove a 2TB disk, add a 4TB disk, wait for end of
> > recovery on three 2TB disks
> 
> If you've got a spare port, the newer mdadm's have, I believe, a "clone
> and replace" option. Much better than failing then rebuilding.

I was not conscious of this option. I understand that it is better because
this prevents me to pass through a "clean, degraded" state ? As I expect that
the clone time will be identical the a recovery one ?

> If not, is it worth getting a SATA expansion board? If you've not got a
> specialist mobo, surely a board is only going to cost a tenner or so,
> and quality isn't *that* important seeing as it's only a temporary measure.

Yes, you're right: it might be worth to purchase another sata controller,
as I have PCI-e free ports, enough alimentation. Maybe a small issue at
disk enclosure level. To be checked... 

> > - at the end of this first phase, I have the same ~6TB RAID 5 clean group
> > with 3 x 4TB + 1 x 2TB disks
> > - declare the last 2 TB disk faulty and remove it
> > - the RAID 5 group state goes to clean, degraded
> > - grow the RAID 5 group with --size=max option
> > - grow the RAID 5 group with --array-size=~12TB option
> > - last, grow the RAID 5 group with --raid-devices=3 and --backup-file=...
> > options.
> > 
> > And I have tested it on a small test RAID 5 group.
> > As expected, this last command makes the RAID 5 group begins a reshaping
> > operation.
> > But this one keeps stucked at zero.
> > 
> > So I have several questions :
> > 
> Don't think I've answered any of them, but I might have raised new ones.
> I just hope the tip saves you a bit of time.

Surely you have opened new pistes. Thanks.

> Cheers,
> Wol
> 
> 
