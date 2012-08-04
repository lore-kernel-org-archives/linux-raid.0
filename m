From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: How does one assemble a DDF or IMSM array?
Date: Sat, 4 Aug 2012 12:16:03 -0400
Message-ID: <20120804161603.GA1030@animx.eu.org>
References: <20120803010532.GA1285@animx.eu.org>
 <501B6C69.8080409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <501B6C69.8080409@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Albert Pauw wrote:
> you can start them by using "mdadm -As", that will start up the
> container first and the other md devices after.
> This will work without mdadm.conf, but it is always good to create a
> proper mdadm.conf (mdadm -Es > /etc/mdadm.conf).
> 
> As for what it is, the container contains the disks (in your case
> sda and sdb), the disks are not the container.
> 
> So you create a container first:
> mdadm -CR /dev/md127 -e ddf -l container -n 2 /dev/sda /dev/sdb
> Create a RAID1 device of 1 GB in there
> mdadm -CR /dev/md0 -l 1 -n 2 /dev/md127 -z  1G
> Create another RAID1 device of 50 MB in there
> mdadm -CR /dev/md1 -l 1 -n 2 /dev/md127 -z 50M
> 
> (in this case both md devices are created on the same two disks).
> 
> If you have e.g. 5 disks you can create two separate RAID1 and RAID5
> devices in the container:
> 
> mdadm -CR /dev/md127 -e ddf -l container -n 2 /dev/sda /dev/sdb
> /dev/sdc /dev/sdd /dev/sde
> mdadm -CR /dev/md0 -l 1 -n 2 /dev/md127
> mdadm -CR /dev/md1 -l 5 -n 3 /dev/md127
> 
> Now, two disk are used fully for the RAID 1 device and three fully
> for the RAID 5 devices, they both have their own set of disks.

I created 2 ddf disks in a container on /dev/sd[ab].  I had 3 MD devices at
that time.

> Stopping them all:
> mdadm -Ss
> 
> Starting them all:
> mdadm -As

This did stop the devices, but would not start them back up.  mdadm 3.2.5
was used.

In your example, suppose I have md0 in use and md1 was not in use and was
stopped.  How would I get md1 started back up w/o shuttind down md0 and
md127?

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
