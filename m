From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Fri, 14 May 2010 07:18:47 -0500
Message-ID: <BA.CE.25297.CAF3DEB4@cdptpa-omtalb.mail.rr.com>
References: <1273820076.5140.2752.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1273820076.5140.2752.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: 'Daniel Reurich' <daniel@centurion.net.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > What type of filesystem is it?
> > >
> > > Try "mount -v /dev/md1 /"
> >
> > 	It doesn't matter what switches I try, it always gives me that
> > error.  The md1 array (/boot) is ext2, and the md2 array (/) is ext3.
> 
> Is mdadm actually assembling the arrays?

	It says it is.  I was able to resync /dev/md3, and I can get the
details on all three arrays from mdadm.  If it weren't assembling them, then
it should return an error when I query for details.
 
> what's the output of: "cat /proc/mdstat"

/dev # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md3 : active raid1 hda3[2] hdb3[1]
      204796548 blocks super 1.2 [2/2] [UU]
      bitmap: 0/196 pages [0KB], 512KB chunk

md2 : active raid1 hda2[2] hdb2[1]
      277442414 blocks super 1.2 [2/2] [UU]
      bitmap: 0/265 pages [0KB], 512KB chunk

md1 : active raid1 hda1[2] hdb1[1]
      6144816 blocks super 1.0 [2/2] [UU]
      bitmap: 0/6 pages [0KB], 512KB chunk

unused devices: <none>

	Note that last response is untrue.  There are 8 drives belonging to
a RAID5 array that is not assembled.  I presume, however, it is basing that
response on the (nonexistent) mdadm.conf file.

