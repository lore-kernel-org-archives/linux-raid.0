From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm --assemble --scan hassles....
Date: Fri, 31 Oct 2003 11:24:10 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16289.43946.51230.934853@notabene.cse.unsw.edu.au>
References: <20031008111709.GV1277@hvs.envisage.co.za>
	<16270.5184.302596.951547@notabene.cse.unsw.edu.au>
	<20031025212433.GE23767@hvs.envisage.co.za>
	<16285.38655.754527.236684@notabene.cse.unsw.edu.au>
	<20031028062445.GD3236@hvs.envisage.co.za>
	<16288.26356.482079.504183@notabene.cse.unsw.edu.au>
	<20031030055625.GE3236@hvs.envisage.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hendrik Visage on Thursday October 30
To: Hendrik Visage <hvisage@envisage.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 30, hvisage@envisage.co.za wrote:
> On Thu, Oct 30, 2003 at 12:18:44PM +1100, Neil Brown wrote:
> > 
> > Show me:
> >  -  your current mdadm.conf
> >  - the output of mdadm -Es -c partitions
> >  - the output of mdadm -Ds
> >  - the output of mdadm -Asv
> > 
> > And I'll try to tell you.
> 
> root@hvstress ~ # mdadm -Es -c partitions
..etc...

Thanks.

So you have to raid arrays:
  md0 is raid0 from 2 scsi partitions and has
                   UUID=832ab839:9920da12:97991965:f9af96e2 
  md1 is linear from another scsi partitions and md0, and has
                   UUID=4478ef04:f7b90666:6a122182:c6b44cf4

So you want mdadm to scan all SCSI partitions and md0, and
to assemble md0 first, then md1.  Identifying partitions
by UUID is easiest so:

 DEVICE /dev/sd* /dev/md0
 ARRAY /dev/md0  UUID=832ab839:9920da12:97991965:f9af96e2 
 ARRAY /dev/md1  UUID=4478ef04:f7b90666:6a122182:c6b44cf4

should do it.  Having "level=xxx" and "num-devices=2" doesn't hurt,
but isn't necessary.

> root@hvstress ~ # cat /etc/mdadm.conf 
> DEVICE /dev/md/* /dev/sd[a-z] partitions /dev/md*
> 
> ARRAY /dev/md/0 level=raid0 num-devices=2 UUID=832ab839:9920da12:97991965:f9af96
> e2
>    devices=/dev/scsi/host0/bus0/target1/lun0/part1,/dev/scsi/host0/bus0/target2/
> lun0/part1
> ARRAY /dev/md/1 level=linear num-devices=2 UUID=c2a91233:5ffd5398:eac27773:e1294
> 5dd
>  devices=/dev/md/0,/dev/scsi/host0/bus0/target1/lun0/part2

I suspect the reason that this didn't work was the devices= lines.
The "/dev/scsi/..." doesn't match (as a string) any of the devices
listed in the DEVICE line.  It is fairly rare that you would need to
want "devices=" entries in mdadm.conf

NeilBrown
