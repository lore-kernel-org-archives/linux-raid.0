From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: How does kernel decide that a drive is "spare"?
Date: Fri, 11 Jun 2010 01:05:18 -0500
Message-ID: <C2.E9.26996.922D11C4@cdptpa-omtalb.mail.rr.com>
References: <loom.20100611T070945-23@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100611T070945-23@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Dave W' <dave+gmane@wuertele.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Dave W
> Sent: Friday, June 11, 2010 12:19 AM
> To: linux-raid@vger.kernel.org
> Subject: How does kernel decide that a drive is "spare"?
> 
> I have a fileserver with a RAID6 on five 2TB drives.  It appeared to be
> working
> fine before I rebooted it, but now it is complaining
> 
> mdadm: /dev/md0 assembled from 2 drives and 3 spares - not enough to start
> the \
> array.
> 
> That's strange... I never configured any spare drives.  There should be

	Any failed drives are moved to spare status.  Issue the `mdadm -D
/dev/mdX` command, and it will probably show 3 failed drives.

> Why are three drives assumed to be spares?

	It's not assumed.  If was almost surely forced by md / mdadm.

> Is there a way for me to recover this array?

	Probably.  No doubt at least one of the drives probably has enough
info on hand to be able to recover most if not all of the information.  You
should be able to force assemble (-A -f) the array using at least 4 drives,
or perhaps all six.  Once assembled, you should be able to fsck the file
system and then mount it and save any critical data off to a backup.  I'd
find out why the drives are being kicked from the array before I tried bring
the array back into production, though, and replace them, or whatever
component is causing them to be kicked.

