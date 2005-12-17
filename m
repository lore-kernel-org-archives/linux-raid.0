From: "John Stoffel" <john@stoffel.org>
Subject: Re: SATA controller order
Date: Fri, 16 Dec 2005 20:15:12 -0500
Message-ID: <17315.26272.349484.657295@smtp.charter.net>
References: <20051216091439.GD24593@atc5.vermine.org>
	<43A28993.9020000@pobox.com>
	<20051216211534.GA14533@atc5.vermine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051216211534.GA14533@atc5.vermine.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Majorel <aym-xunil@teaser.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Andre> On 2005-12-16 04:32 -0500, Jeff Garzik wrote:
>> Andre Majorel wrote:
>> 
>> >I have a motherboard with two SATA chips (Nvidia nForce 4 and
>> >Silicon Image SiI 3114) running Linux 2.6.14.3. The drivers are
>> >SCSI_SATA_NV and SCSI_SATA_SIL, both compiled-in.                          
>> >                                                                                
>> >Ports on the SiI 3114 controller are assigned scsi0 through
>> >scsi3 and ports on the nForce4 chip are assigned scsi4 through
>> >scsi7. Is there any way to control the order so that SCSI_SATA_NV
>> >gets scsi0-scsi3 and SCSI_SATA_SIL gets scsi4-scsi7 instead ?
>> 
>> Use modules,

Andre> But then wouldn't I have to use initrd if / is on a raid device ?

So?  I've been planning for a long time to mirror my / and /boot
partitions, I've even got the empty disk to do it with, just haven't
done it yet.  And I've got my /home and /local partitions mirrored
which has saved my butt a couple of times now.

Andre> OK. This did the trick :

[ patch deleted ]

You do realize that this patch won't get accepted into the main
kernel, so you'll have to keep re-applying it (and remembering to)
each time you install a new kernel.  Is it really worth it?

For one thing, since mdadm doesn't care where disks are located, just
use a mdadm.conf file with a line saying 'DEVICE partitions' so that
it will search all partitions it finds for MD devices.

Then you have your filesystems listed by UUID, so they don't have to
be completely specified either.

Basically, let the computer find your data, and don't sweat where it's
located if you can help it.

John
