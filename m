From: "Ionut Nistor" <ionut@modulo.ro>
Subject: Re: Multipath problem in a SAN enviromnent
Date: Thu, 12 Jun 2003 09:28:11 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00bf01c330ab$cca59390$3351960a@EEL>
References: <02d201c33023$13fd45a0$3351960a@EEL> <3EE7585E.45D851CE@SteelEye.com> <038101c33038$e8a6e760$3351960a@EEL> <3EE76DEF.C950D9C3@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

When you're talking about mapping, you only reffer to SCSI IDs (i.e.
targets). I found no way of mapping the LUN IDs to specific kernel devices.
When you're using controllers with multiple disks and you map SCSI IDs to
devices all is fine. The problem appears when you are dealing with shifting
LUNs.

Matching *could* be done by raid superblock UUID (mdadm does such a thing)
but, if the major an minor in the superblock (the ones that reffer to 'this'
disk) are not the 'real' ones, md goes bezerk.

More specific, as in my initial example,

scsi1, bus0, target0, lun2 was 8,32
when scsi1, bus0, target0, lun1 is removed and you reload the FC HBA module,
scsi1, bus0, target0, lun2 becomes 8,16

When MD starts (the first disk in raidtab is /dev/sdb - cause i've changed
it to match the configuration - if using devfsd no change necessary at this
level) it looks in the superblock and finds
8,32 and 8,64 - obviously they are not the same and multipath crashes.

Ionut


----- Original Message ----- 
From: "Paul Clements" <Paul.Clements@SteelEye.com>
To: "Ionut Nistor" <ionut@modulo.ro>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, June 11, 2003 8:59 PM
Subject: Re: Multipath problem in a SAN enviromnent


> Ionut Nistor wrote:
> >
> > Yes, you would get around it. But the main point of the superblock (i.e.
> > disk membership/status/array uuid) is to be able to identify the disks
in an
> > array if devices allocation changes.
> >
> > There must be a *safe* way of identifying the devices.
>
> I agree that for most raid levels this is the case, but for multipath
> there's nothing unsafe about probing the paths at boot time and
> assembling the multipath md devices by matching up SCSI IDs (or FC
> WWNs). This is how the QLogic (and other) HBA drivers do their multipath
> setup.
>
> But getting back to the original problem, it does seem like we should be
> looking for matching superblock UUID (only) on the different paths
> rather than matching major,minor since those can obviously change.
>
> Could you maybe post your boot messages (from md) so we can see what md
> thinks is going on? I assume your partitions are IDed as RAID (0xfd) and
> you're using the md autorun feature to start up your arrays?
>
> --
> Paul

