From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID 0+1 with mdadm.
Date: Thu, 27 Jan 2005 16:30:59 +1100
Message-ID: <16888.31891.953961.175508@cse.unsw.edu.au>
References: <1106692101.15355.16.camel@serpent>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brad Dameron on Tuesday January 25
Sender: linux-raid-owner@vger.kernel.org
To: Brad Dameron <brad@seatab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 25, brad@seatab.com wrote:
> Been trying for days to get a software RAID 0+1 setup. This is on SuSe
> 9.2 with kernel 2.6.8-24.11-smp x86_64.
> 
> I am trying to setup a RAID 0+1 with 4 250gb SATA drives. I do the
> following:
> 
> mdadm --create /dev/md1 --level=0 --chunk=4 --raid-devices=2 /dev/sdb1
> /dev/sdc1
> mdadm --create /dev/md2 --level=0 --chunk=4 --raid-devices=2 /dev/sdd1
> /dev/sde1
> mdadm --create /dev/md0 --level=1 --chunk=4 --raid-devices=2 /dev/md1
> /dev/md2
> 
> This all works fine and I can mkreiserfs /dev/md0 and mount it. If I am
> then to reboot /dev/md1 and /dev/md2 will show up in the /proc/mdstat
> but not /dev/md0. So I create a /etc/mdadm.conf like so to see if this
> will work:
> 
> DEVICE partitions
> DEVICE /dev/md*
> ARRAY /dev/md2 level=raid0 num-devices=2
> UUID=5e6efe7d:6f5de80b:82ef7843:148cd518
>    devices=/dev/sdd1,/dev/sde1
> ARRAY /dev/md1 level=raid0 num-devices=2
> UUID=e81e74f9:1cf84f87:7747c1c9:b3f08a81
>    devices=/dev/sdb1,/dev/sdc1
> ARRAY /dev/md0 level=raid1 num-devices=2  devices=/dev/md2,/dev/md1
> 
> 
> Everything seems ok after boot. But again no /dev/md0 in /proc/mdstat.
> But then if I do a mdadm --assemble --scan it will then load
> /dev/md0. 

My guess is that you are (or SuSE is) relying on "autodetect" to
assemble the arrays.  Autodetect cannot assemble an array made of
other arrays.  Just an array made of partitions.

If you disable the autodetect stuff and make sure 
  mdadm --assemble --scan
is in a boot-script somewhere, it should just work.

Also, you don't really want the "device=/dev/sdd1..." entries in
mdadm.conf.
They tell mdadm to require the devices to have those names.  If you
add or remove scsi drives at all, the names can change.  Just rely on
the UUID.

> 
> Also do I need to create partitions? Or can I setup the whole drives as
> the array?

You don't need partitions.

> 
> I have since upgraded to mdadm 1.8 and setup a RAID10. However I need
> something that is production worthy. Is a RAID10 something I could rely
> on as well? Also under a RAID10 how do you tell it which drives you want
> mirrored?

raid10 is 2.6 only, but should be quite stable.
You cannot tell it which drives to mirror because you shouldn't care.
You just give it a bunch of identical drives and let it put the data
where it wants.

If you really want to care (and I cannot imagine why you would - all
drives in a raid10 are likely to get similar load) then you have to
build it "by hand" - a raid0 of multiple raid1s.

NeilBrown
