From: <robin-lists@robinbowes.com>
Subject: RE: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25 kernel
Date: Thu, 5 Aug 2004 16:42:25 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S267762AbUHEPma/20040805154230Z+368@vger.kernel.org>
References: <cet7vc$mt7$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cet7vc$mt7$1@sea.gmane.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jens Benecke
> Sent: 05 August 2004 12:08
> To: linux-raid@vger.kernel.org
> Subject: RE: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', 
> homebrew 2.4.25 kernel
> 
> robin-lists@robinbowes.com wrote:
> 
> >> >> How about RAIDing the root partition? If one drive 
> fails will the 
> >> >> other be able to boot via LILO? How about GRUB? Which do
> >> > 
> >> > I have my root partition on a RAID1 mirror. I use grub and have 
> >> > "installed" grub to both mirrored drives so I can boot 
> off either, 
> >> > e.g. if one fails. That reminds me, I must test this.
> >> 
> >> That's exactly what I want.
> > 
> > I've got some rough notes I made. I may tidy them up and 
> publish them 
> > on my web site.
> 
> Hi Robin,
> 
> I'm still a bit torn between buying a 3ware hardware RAID for 
> ?140.- and just using 'md'. The box is an Athlon64 3GHz, so 
> it'll have enough CPU power to do the RAID in software, but 
> with partitioning etc, I think the hardware raid will be 
> easier to handle because you can just ignore it. As long as 
> the 3ware BIOS will handle failing drives, read/write errors, 
> etc etc. properly.
> 
> Right?

Not sure what your question is. 3ware cards are generally held in high
regard, although I have seen some traffic about performance problems,
although these seem to be contradicted by an equal number of "it works Ok
for me" traffic.

I needed at least 6 x 250GB drives so the 3Ware option was a little pricey,
hence my decision to go with md.

>     
> >> > keep /var/tmp and /tmp on the root partition.
> >> 
> >> No. I don't want a rogue script to fill up my root partition.
> > 
> > That, of course, is the reason you would want to keep 
> /var/tmp and/or 
> > /tmp on separate partitions (or on the same partition - 
> just symlink 
> > so /var/tmp and /tmp are the same.)
> 
> I would probably not symlink but I'd put them both on the 
> same partition. 

I have a separate /var partition so I will just symlink /tmp to /var/tmp.

>   
> >> What I mean is, will md resync automatically or would I have to 
> >> initiate this manually?
> > 
> > Md should re-sync automatically.
> 
> ... even onto a new blank disk? Or would you have to tell md 
> manually "this is the new spare, please sync"? Is this easy 
> to do? Something like
> 
>         - copy partition table
>         - for FOO in 1 2 3 4 5 ; do tell md "sync hda$FOO to hdc$FOO"
> 
> or is it more complicated?

Now that you've made me think about it I'm not entirely sure. I would do
this:

(assume /dev/sdc has failed).

Shutdown server.
Pull dead drive
Insert new drive
Boot up server

# sfdisk -d /dev/sda | sfdisk /dev/sdc

Now, it might be necessary to explicitly "remove" the failed device from the
arrays (before shutting down?) and to add it back in after replacing the
disk but I don't know.

I'm sure there are others on this list who can keep us right!

For example, would this work?:

# mdadm /dev/md5 -f /dev/sdc2 -r /dev/sdc2 -a /dev/sdc2

According to my understanding, this does the following:

1. Marks /dev/sdc2 as faulty in /dev/md5 (if the drive has failed it should
already be marked faulty??)
2. removes /dev/sdc2 from /dev/md5
3. Adds /dev/sdc2 to /dev/md5

Can anyone else clarify this?

> >> This setup seems quite complicated. Did you test the setup, ie. 
> >> removed one of the MD disks and looked what happened?

I really ought to do this before I put the machine into "production"!

> > I deliberated long and hard about how to implement my new 
> system and 
> > this was about the least complicated route!
> 
> Oh. ;)
>  
> 
> >> >> The goal is to have as "stress free" a system as possible as 
> >> >> little manual configuration, and in event of emergencies, as 
> >> >> little work to do, as possible.
> >> > If you want stress free, buy a Netapps storage appliance ;o)
> >> If they do all the rest that I need (smtp, web, file server,
> > I was being slightly slippant - Netapps just do big storage arrays 
> > with very high availability. For example, if they detect 
> that a drive 
> > is failing they send an email to Netapps and an engineer 
> comes round 
> > with a replacement disk all without any user intervention! I guess 
> > they're the Rolls Royce of storage solutions. Expensive though.
> 
> Ah. Well I don't think this'll fit in our budget. :)

That should of course have read "flippant". But I think you got my meaning.
:)
 
R.
--
http://robinbowes.com  

