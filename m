From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: Find the mirror and sriping disks
Date: Wed, 12 Dec 2012 16:09:15 -0600
Message-ID: <8FD5A458-55DA-4471-BCC3-63ED6919030A@redhat.com>
References: <1355338248.8226.androidMobile@web190604.mail.sg3.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1355338248.8226.androidMobile@web190604.mail.sg3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kks Kbase <kks.kbase@yahoo.in>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Right.

That is for the "near" algorithm.  It is possible to do different kinds of layouts if you like too (e.g. the "far" and "offset" algorithms).  These are also explained in the wiki page, I think.

For some great RAID information, also see:
http://www.snia.org/sites/default/files/SNIA_DDF_Technical_Position_v2.0.pdf

 brassow

On Dec 12, 2012, at 12:50 PM, Kks Kbase wrote:

> Hey,
> 
> Great! So if the server with raid10 sda1,sdb1,sdc1 and sdd1 then the pair's sda1 and sdb1 as well sdc1 and sdd1 are mirrored pair and the dAta stripe between these pairs right?
> 
> 
> 
> From: Brassow Jonathan <jbrassow@redhat.com>; 
> To: Kks Kbase <kks.kbase@yahoo.in>; 
> Cc: Linux Raid <linux-raid@vger.kernel.org>; 
> Subject: Re: Find the mirror and sriping disks 
> Sent: Wed, Dec 12, 2012 2:47:48 PM 
> 
> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
> 
> I also verified the layout of the various algorithms by writing a sequence of characters (A, B, C...) in stripe-width/chunk sizes.  Then I used 'hexdump -c' to look at each disk.  Works well.
> 
> brassow
> 
> On Dec 7, 2012, at 1:00 AM, Kks Kbase wrote:
> 
> > Hi Folks,
> > 
> > I have setup S/w raid level 10 with 6 disks. May I know how to find the mirrored and striped disks on my raid 10?
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

