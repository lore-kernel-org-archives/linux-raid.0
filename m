From: Gordon Henderson <gordon@drogon.net>
Subject: Re: /dev/md* Device Files
Date: Wed, 26 Jan 2005 07:28:33 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501260726100.12589@lion.drogon.net>
References: <Pine.LNX.4.61.0501251445420.6553@electra.rsc.raytheon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0501251445420.6553@electra.rsc.raytheon.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Witt <sawitt@electra.rsc.raytheon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 25 Jan 2005, Steve Witt wrote:

> I'm installing a software raid system on a new server that I've just
> installed Debian 3.1 (sarge) on. It will be a raid5 on 5 IDE disks using
> mdadm. I'm trying to create the array with 'mdadm --create /dev/md0 ...'
> and am getting an error: 'mdadm: error opening /dev/md0: No such file or
> directory'. There are no /dev/md* devices in /dev at the present time. I
> do have the md and raid5 kernel modules loaded. My question is: how do the
> /dev/md* files get created? Are they normal device file that are created
> with MAKEDEV?

It's odd that they aren't there - they are with Debian 3.0, and have
remained there when I've upgraded a few test servers to testing/Sarge.

	# cd /dev
	# ./MAKEDEV md

should do the business.

Gordon
