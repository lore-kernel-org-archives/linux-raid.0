From: John Lange <john.lange@bighostbox.com>
Subject: Re: AW: Raid 1 vs 5 ?
Date: Fri, 07 May 2004 10:15:39 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1083942939.6646.17.camel@ws101.darkcore.net>
References: <FA095C015271B64E99B197937712FD0227A85D@freedom.grz.icomedias.com>
	 <1083909121.4287.19.camel@localhost>  <200405071629.31420.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200405071629.31420.maarten@vbvb.nl>
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you all for your advice. Very helpful and informative.

I have one final followup.

As this RAID 5 array will be comprised of 4 nearly 80Gig serial ata
disks, should I be using a larger chunk-size than 32 ? The software raid
how-to hints that it should be larger but doesn't go into detail on what
size should be used.

By my calculation this will be a 225G (4 disk) raid 5 array.

((4-1)* 75G) = 225G

My google for it turned up all sorts of conflicting advice on
chunk-size.

Regards,

John Lange

On Fri, 2004-05-07 at 09:29, Maarten van den Berg wrote:
> On Friday 07 May 2004 07:52, John Lange wrote:
> > Thank you Martin. You have some really great insights there.
> >
> > A couple of things about the raid sets confused me:
> > > Each disk partitioned alike:
> > > 	1	30MB
> > > 	2	1/2 size_of_swap_
> > > 	5	rest_of_disk
> > >
> > > Now you can create mds on the disk:
> > > 	md0	raid1 sda1 sda2 sda3 sda4
> > > 	md1	raid1 sda1 sdb1
> > > 	md2	raid1 sdc1 sdd1
> > > 	md3	raid5 sda5 sdb5 sdc5 sdd5
> >
> > First, why do we skip sdx3 and sdx4 on each disk and go directly to sdx5
> > for partition numbers?
> 
> That is the first number a logical partition gets, as opposed to primary.
> 
> > Second, I'm very confused by the way you divided up the raid sets....
> > I'm thinking you erred? I'm such a newb its possible I really don't
> > understand whats going on so hopefully you can verify.
> 
> I concur, there are errors. This is probably what he meant
> 
> > md0: did you mean sda1 sdb1 sdc1 sdd1 ?
> 
> Yes. It was obviously a typo.
> 
> > md1: did you mean sda2 sdb2 ?
> > md2: did you mean sdc2 sdd2 ?
> 
> If it were me, why not do entire swap (not 1/2 size_of_swap) on a four-way 
> raid 1, just as with /boot ?  Is way simpler.
> 
> > md3: did you mean sda5 sdb5 sdc5 sdd5 ?
> >
> > And last, is it possible to build the system from the beginning on RAID?
> > I'm using slackware. I see there is a section in the how-to for
> > converting a red hat system after the fact but obviously it would be
> > easier if I didn't have to do that.
> 
> What proved the easiest for me is installing the OS on a temporary scrap 
> harddisk, build your raid sets from there on the real target disks and copy.
> There is a more complicated way too, it involves setting failed-disk status on 
> the drive holding your original data. 
> 
> Maarten
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
John Lange
BigHostBox.com
(204) 885 0872

