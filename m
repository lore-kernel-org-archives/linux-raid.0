From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: RE: /dev/md* Device Files
Date: Wed, 26 Jan 2005 16:10:54 -0600
Message-ID: <OMEKLMBKKEOEENCKLEIDKECLCBAA.ryan@dynaconnections.com>
References: <Pine.LNX.4.61.0501251445420.6553@electra.rsc.raytheon.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0501251445420.6553@electra.rsc.raytheon.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Witt <sawitt@electra.rsc.raytheon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Did you have the md module inserted into the kernel at this point?  It
should automatically the md device entries for you, at least it does with
udev-045.

-ryan

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Steve Witt
Sent: Tuesday, January 25, 2005 4:54 PM
To: linux-raid@vger.kernel.org
Subject: /dev/md* Device Files


I'm installing a software raid system on a new server that I've just
installed Debian 3.1 (sarge) on. It will be a raid5 on 5 IDE disks using
mdadm. I'm trying to create the array with 'mdadm --create /dev/md0 ...'
and am getting an error: 'mdadm: error opening /dev/md0: No such file or
directory'. There are no /dev/md* devices in /dev at the present time. I
do have the md and raid5 kernel modules loaded. My question is: how do the
/dev/md* files get created? Are they normal device file that are created
with MAKEDEV?

Thanks...

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

