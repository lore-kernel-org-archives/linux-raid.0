From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Multipath problem
Date: Tue, 30 Nov 2004 13:44:01 +1100
Message-ID: <16811.56945.96477.985675@cse.unsw.edu.au>
References: <41A32AE7.2080502@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Oliver Heinz on Tuesday November 23
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Heinz <oheinz@fbihome.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 23, oheinz@fbihome.de wrote:
> Hi,
> 
> I'm trying to setup a HP packaged cluster (2xDL380G4 Servers +MA500G2 
> Storage) both Servers  are connected via 2 SCSI-Links one for each of 
> the storages's redundancy controllers.
> The Storage shows as /dev/cciss/c0d1 and /dev/cciss/c1d0. When I create 
> an multipath md device with version 1.6 of mdadm I can create it but 
> restarting the array after I stopped it fails. With version 1.8.2 the 
> size of the generated Array is 0 Blocks but I can restart it (which buys 
> me nothing with that size ;-)
> 
> Mixing mdadm-1.6 and 1.8.1 for creating/managing the device doesn't 
> work, it gives me an segfault.

mdadm 1.8.0 is the version I would recommend.  1.8.1 is a development
release.

> server-b:/usr/src/packages# mdadm -A /dev/md0 -f /dev/cciss/c1d0 
> /dev/cciss/c0d1
> mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument
> 

If this still happens with 1.8.0, could you see if there are any
messages in the kernel log (e.g. output of 'dmesg'), and send them to
me.

Thanks,
NeilBrown
