From: Clive Messer <clive@vacuumtube.org.uk>
Subject: Re: Moving a raid5 array
Date: Tue, 12 Sep 2006 17:35:43 +0100
Message-ID: <200609121735.43261.clive@vacuumtube.org.uk>
References: <200609121714.58541.clive@vacuumtube.org.uk> <17670.56982.310173.651209@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17670.56982.310173.651209@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 12 September 2006 17:21, Neil Brown wrote:
> On Tuesday September 12, clive@vacuumtube.org.uk wrote:
> > I currently have a 4 disk raid5 array which I wish to move to another
> > machine. In the current machine it is comprised of sda1/sdb1/sdc1/sdd1.
> > When I move it to the new machine the disks will all shift up by 2. ie.
> > the partitions will now be sdc1/sdd1/sde1/sdf1. If I 'mdadm --assemble'
> > the array on the new machine with the new partition names will md figure
> > it all out or am I going to trash my data?
> >
> > For reference my current mdadm.conf ......
> >
> > DEVICE /dev/sd*[0-9]
> > ARRAY /dev/md0 level=raid5 num-devices=4
> > UUID=f1949e2c:bec621e4:de55ae15:4f336899
>
> Providing you don't already have a /dev/md0 on the new machine, which
> should work perfectly - no confusion.

Thanks Neil. Appreciate the quick response.

Regards

Clive
-- 
Clive Messer <clive@vacuumtube.org.uk>
