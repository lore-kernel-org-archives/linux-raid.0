From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: 3ware and scsi ids
Date: Tue, 10 Jun 2003 12:21:12 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE60578.15B28E20@SteelEye.com>
References: <12F8DBE91382164-01@MMS__ad.corp.aoltw.net_>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Deas, Jim" <James.Deas@warnerbros.com>
Cc: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Deas, Jim" wrote:
> 
> Have you tried this on the 3ware product? They do not
> return scsi data as a normal drive would. As far as I
> can tell, without making a 3ware specific system call
> you can not get a unique serial number from the drives.

The UUID referenced below is gotten from the md device superblock (data
written to the end of the disk) so there shouldn't be any issues with
devices that do not return a valid SCSI serial number or device ID.

--
Paul 


 
> -----Original Message-----
> From: Friedrich Lobenstock [mailto:fl@fl.priv.at]
> Sent: Friday, June 06, 2003 4:51 PM
> To: Linux RAID Mailing Liste
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: 3ware and scsi ids
> 
> Deas, Jim wrote:
> > I am currently using 3wares products to create 2T raids.
> > To increase performance on my NAS type boxes I am
> > using software raids.
> >  My problem relates to a falure of a IDE drive.
> > Once a drive fails the next boot of the machine remaps all scsi ids.
> > so /dev/sda-adi becomes /dev/sda-sdh.
> > In short, if /dev/sdb dies, all raids become bad as all scsi ids
> > shift down making my raidtab file now point at the wrong drives.
> > (I assume this will also be a possible problem when I use
> > my USB dongle to update software.)
> >
> >  Is there a way to hard assign logical /dev/sd(x) in the driver
> > so they will always map the same ide port on the 3ware controllers?
> > 3ware is no help on this. They say it is the bios/system and they
> > have no control over this.
> 
> You'd better use mdadm instead of the raidtools.
> 
> The config file for mdadm looks like this:
> # cat /etc/mdadm.conf
> DEVICE /dev/hd* /dev/sd*
> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=52094036:b2e9cf8b:4267c923:750757da
> 
> So you do not have to worry about which drive gets assigned which
> scsi id.
> 
> A
>     /sbin/mdadm --assemble --scan
> will do the trick.
> 
> Get it at http://www.cse.unsw.edu.au/~neilb/source/mdadm/
> 
> --
> MfG / Regards
> Friedrich Lobenstock
> ____________________________________________________________________
> Friedrich Lobenstock                       Linux Services Lobenstock
> URL: http://www.lsl.at/                         Email: fl@fl.priv.at
> ____________________________________________________________________
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
