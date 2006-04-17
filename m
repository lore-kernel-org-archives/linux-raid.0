From: Nathanial Byrnes <nate@qabal.org>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Mon, 17 Apr 2006 06:08:27 -0400
Message-ID: <1145268508.18173.61.camel@nemo.qabal.org>
References: <1145106091.18173.18.camel@nemo.qabal.org>
	 <17474.51499.479497.322081@cse.unsw.edu.au>
	 <1145242458.18173.49.camel@nemo.qabal.org>
	 <17475.1455.344850.506978@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17475.1455.344850.506978@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please see below.

On Mon, 2006-04-17 at 13:04 +1000, Neil Brown wrote:
> On Sunday April 16, nate@qabal.org wrote:
> > Hi Neil,
> > 	Thanks for your reply. I tried that, but here is there error I
> > received:
> > 
> > root@finn:/etc# mdadm --assemble /dev/md0
> > --uuid=38081921:59a998f9:64c1a001:ec53 4ef2 /dev/hd[efgh]
> > mdadm: failed to add /dev/hdf to /dev/md0: Device or resource busy
> > mdadm: /dev/md0 assembled from 2 drives and -1 spares - not enough to
> > start the array.
> 
> What is /dev/hdf busy? Is it in use? mounted? something?
> 
Not that I am aware of. Here is the mount output:

root@finn:/etc# mount
/dev/sda1 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
/dev/sdb1 on /usr type ext3 (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
nfsd on /proc/fs/nfsd type nfsd (rw)
usbfs on /proc/bus/usb type usbfs (rw)

lsof | grep hdf does not return any results.

is there some other way to find out?
> > 
> > The output from lsraid against each device is as follows (I think that I
> > messed up my superblocks pretty well...): 
> 
> Sorry, but I don't use lsraid and cannot tell anything useful from it's
> output.
ok
> 
> NeilBrown
> 
> !DSPAM:444305b971501811819476!
> 

