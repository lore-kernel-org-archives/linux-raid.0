From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Multipath problem in a SAN enviromnent
Date: Wed, 11 Jun 2003 13:59:11 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE76DEF.C950D9C3@SteelEye.com>
References: <02d201c33023$13fd45a0$3351960a@EEL> <3EE7585E.45D851CE@SteelEye.com> <038101c33038$e8a6e760$3351960a@EEL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Ionut Nistor <ionut@modulo.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ionut Nistor wrote:
> 
> Yes, you would get around it. But the main point of the superblock (i.e.
> disk membership/status/array uuid) is to be able to identify the disks in an
> array if devices allocation changes.
> 
> There must be a *safe* way of identifying the devices.

I agree that for most raid levels this is the case, but for multipath
there's nothing unsafe about probing the paths at boot time and
assembling the multipath md devices by matching up SCSI IDs (or FC
WWNs). This is how the QLogic (and other) HBA drivers do their multipath
setup.

But getting back to the original problem, it does seem like we should be
looking for matching superblock UUID (only) on the different paths
rather than matching major,minor since those can obviously change. 

Could you maybe post your boot messages (from md) so we can see what md
thinks is going on? I assume your partitions are IDed as RAID (0xfd) and
you're using the md autorun feature to start up your arrays?

--
Paul

 
> ----- Original Message -----
> From: "Paul Clements" <Paul.Clements@SteelEye.com>
> To: "Ionut Nistor" <ionut@modulo.ro>
> Cc: <linux-raid@vger.kernel.org>
> Sent: Wednesday, June 11, 2003 7:27 PM
> Subject: Re: Multipath problem in a SAN enviromnent
> 
> > Ionut Nistor wrote:
> >
> > > So scsi1, bus0, target0, lun2 is now 8,16 instead of 8,32
> > >
> > > However, the raid superblock still has 8,32 in it - this confuses
> > > multipath
> >
> > One way to get around this problem is to use non-persistent superblocks
> > for your arrays and just re-create them at bootup time by calling mkraid
> > (or mdadm) after you've correctly identified (using WWID or similar)
> > which devices belong to each particular raid set.
> >
> > --
> > Paul
> >
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
