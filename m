From: <robin-lists@robinbowes.com>
Subject: RE: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25 kernel
Date: Thu, 5 Aug 2004 10:57:03 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S267610AbUHEJ5F/20040805095705Z+97@vger.kernel.org>
References: <cesjcm$9da$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cesjcm$9da$1@sea.gmane.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jens Benecke
> Sent: 05 August 2004 06:17
> To: linux-raid@vger.kernel.org
> Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', 
> homebrew 2.4.25 kernel
> 
> Robin Bowes wrote:
> 
> > On Wed, August 4, 2004 9:42, Jens Benecke said:

> > 
> > I use md and mdadm on Fedora Core 2. What distro are you 
> contemplating?
> 
> Hi,
> 
> see subject (Debian). I've looked at SuSE though, it seems 
> with their setup RAID and ReiserFS is much easier to handle. 
> I'm running SuSE at home though and the sheer number of 
> security updates that come in kind of make me a bit uneasy 
> for an internet server.

Ooops./ I didn't read the subject.

> >> How about RAIDing the root partition? If one drive fails will the 
> >> other be able to boot via LILO? How about GRUB? Which do 
> you prefer?
> > 
> > I have my root partition on a RAID1 mirror. I use grub and have 
> > "installed" grub to both mirrored drives so I can boot off either, 
> > e.g. if one fails. That reminds me, I must test this.
> 
> That's exactly what I want.

I've got some rough notes I made. I may tidy them up and publish them on my
web site.
   
> >> How about (/var)/tmp? I (suppose I'll) need it on both 
> disks, does it 
> >> make sense to mirror it as well?
> > 
> > You *could* put /var/tmp or /tmp on separate partitions either 
> > mirrored or not, but if you want to keep things "stress 
> free" I would 
> > keep /var/tmp and /tmp on the root partition.
> 
> No. I don't want a rogue script to fill up my root partition.

That, of course, is the reason you would want to keep /var/tmp and/or /tmp
on separate partitions (or on the same partition - just symlink so /var/tmp
and /tmp are the same.)

>  
> >> Can I mirror the whole disk? Or do I need to mirror each partition 
> >> seperately?
> > 
> > You can do either. You mirror the disk using md and can then either 
> > create a filesystem on the whole disk, or use lvm to create logical 
> > volumes within the md device.
> 
> Hm... I thought LVM did mirroring and striping as well? I 
> didn't think you can or should use them together. Wouldn't 
> that degrade performance as well?
>  
> >> Does MD or LVM2 do hot sync, i.e. if one drive fails will 
> I be able 
> >> to stick in a replacement, and stop worrying? Or do I need to 
> >> repartition the new disk exactly as the old one, before 
> being able to sync?
> > 
> > I'm not sure about this. My understanding is that you will need to 
> > shutdown the system to replace the bad disk and partition 
> the new disk 
> > manually before md will resync, but this could be wrong.
> 
> What I mean is, will md resync automatically or would I have 
> to initiate this manually?

Md should re-sync automatically.

>  
> > I have six 250GB SATA disks, all partitioned identically with two 
> > partitions of 1.5GB and 248.5 GB. I have them configured as RAID 
> > devices using md follows:
> 
> I think you mean 1.5TB. :-)

Nope, 1.5GB. See below.

>  
> > md0   sda1 + sdd1    RAID1    1.5GB   root filesystem
> > md2   sdb1 + sde1    RAID1    1.5GB   swap 1
> > md3   sdc1 + sdf1    RAID1    1.5GB   currently not used
> > md5   sd[abcdef]2    RAID5    994GB   lvm2 volume group (4+1+spare)
> > 
> > Then within the lvm2 volume group I have the following 
> logical volumes:
> > 
> > dude_usr   10GB     /usr
> > dude_var   5GB      /var
> > dude_home  979GB    /home
> > 
> > I did my initial install just to the mirrored root parition 
> . Once I 
> > had done the initial install I set up the lvm2 array and 
> volumes and 
> > migrated /usr and /var over.
> > 
> > It's working great so far.
> 
> This setup seems quite complicated. Did you test the setup, 
> ie. removed one of the MD disks and looked what happened?

I deliberated long and hard about how to implement my new system and this
was about the least complicated route!

> >> The goal is to have as "stress free" a system as possible 
> - i.e. with 
> >> as little manual configuration, and in event of emergencies, as 
> >> little work to do, as possible.
> > 
> > If you want stress free, buy a Netapps storage appliance ;o)
> 
> If they do all the rest that I need (smtp, web, file server, 
> ftp server, mysql, spamassassin, etc etc etc) fine. If not, 
> I'd need to set up another box anyway, so I wouldn't see the 
> advantage.

I was being slightly slippant - Netapps just do big storage arrays with very
high availability. For example, if they detect that a drive is failing they
send an email to Netapps and an engineer comes round with a replacement disk
all without any user intervention! I guess they're the Rolls Royce of
storage solutions. Expensive though.

R.
--
http://robinbowes.com  

