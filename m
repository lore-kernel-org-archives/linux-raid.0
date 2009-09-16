From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Assemble and Stop array
Date: Wed, 16 Sep 2009 00:09:05 -0500
Message-ID: <20090916050920375.VUFJ26991@cdptpa-omta03.mail.rr.com>
References: <20090915233517830.IGLE14103@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090915233517830.IGLE14103@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hmm.  That didn't look very good when I got the reflected message.  Perhaps
re-quoting it will provide a better format:

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Leslie Rhorer
> Sent: Tuesday, September 15, 2009 6:35 PM
> To: linux-raid@vger.kernel.org
> Subject: Assemble and Stop array
> 
> 
> 	I'm still trying to wrap my mind around two items.
> 
> 	One is stopping an array.  From time to time I need to stop an array
> for some reason, but I am persistently having trouble doing so.  It
> doesn't
> always happen, and sometimes when it does I can free it up by doing
> `exportfs -ua` and `umount -l /xxxxx`, but other times it simply cannot be
> done and my only recourse is to reboot the system.  These are simple RAID5
> or RAID6 arrays on raw drives with a single file system formatted on the
> unpartitioned array.  None of the drives are used for booting or for swap,
> there is no loop device and lsof shows no open files, but mdadm -S still
> fails with a device busy error.  Every time it has happened, a simple
> umount
> command without the -l switch fails, but a "lazy" umount appears to work,
> with the exception that sometimes I still cannot stop the array.  Clearly,
> the NFS export is sometimes the culprit, but not always.  What else can it
> be?
> 
> 	The second item is assembling an array which was formerly stopped.
> By my reading, `mdadm --assemble --scan` should work, but it doesn't.  It
> keeps telling me no devices are found for the array.  Here is a sample
> from
> one of the /etc/mdadm/mdadm.conf files:
> 
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
> 
> # auto-create devices with Debian standard permissions
> CREATE owner=root group=disk mode=0660 auto=yes
> 
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
> 
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR lrhorer@satx.rr.com
> 
> # This file was auto-generated on Fri, 21 Nov 2008 22:35:30 -0600
> # by mkconf $Id$
> PROGRAM /usr/bin/mdadm_notify
> DEVICE /dev/sd[a-j]
> ARRAY /dev/md/0 level=raid6 metadata=1.2 num-devices=10
> UUID=5ff10d73:a096195f:7a646bba:a68986ca name=RAID-Server:0
> 
> When I manually assemble the array, I wind up having to re-create the
> bitmap
> file, as well.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

