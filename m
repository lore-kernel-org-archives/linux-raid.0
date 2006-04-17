From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Mon, 17 Apr 2006 20:29:36 +1000
Message-ID: <17475.28176.159396.519547@cse.unsw.edu.au>
References: <1145106091.18173.18.camel@nemo.qabal.org>
	<17474.51499.479497.322081@cse.unsw.edu.au>
	<1145242458.18173.49.camel@nemo.qabal.org>
	<17475.1455.344850.506978@cse.unsw.edu.au>
	<1145268508.18173.61.camel@nemo.qabal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nathanial Byrnes on Monday April 17
Sender: linux-raid-owner@vger.kernel.org
To: Nathanial Byrnes <nate@qabal.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 17, nate@qabal.org wrote:
> > 
> > What is /dev/hdf busy? Is it in use? mounted? something?
> > 
> Not that I am aware of. Here is the mount output:
> 
> root@finn:/etc# mount
> /dev/sda1 on / type ext3 (rw)
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> /dev/sdb1 on /usr type ext3 (rw)
> devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> nfsd on /proc/fs/nfsd type nfsd (rw)
> usbfs on /proc/bus/usb type usbfs (rw)
> 
> lsof | grep hdf does not return any results.
> 
> is there some other way to find out?

 cat /proc/swaps
 cat /proc/mounts
 cat /proc/mdstat

as well as 'lsof' should find it.

