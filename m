From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: mdadm spare-group not working for me
Date: Wed, 28 Jul 2004 07:32:12 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407280712140.31636@praktifix.dwd.de>
References: <Pine.LNX.4.58.0407070745260.20019@praktifix.dwd.de>
 <16619.54193.685669.468567@cse.unsw.edu.au> <Pine.LNX.4.58.0407071114270.20019@praktifix.dwd.de>
 <16640.34365.538177.870871@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16640.34365.538177.870871@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 23 Jul 2004, Neil Brown wrote:

> On Wednesday July 7, Holger.Kiehl@dwd.de wrote:
> > 
> > Is it possible to influence the order at which the spares are taken
> > from the group? Reason is that I have four spare partitions on two
> > ide disks (2 partitions on each disk). Removing a second disk I
> > noticed it picked the second partition from the same disk. The spares
> > where added in this order hde7 hda7 hde6 hda6, but mdadm picked hde7
> > and then hde6. Better would be hde then hda.
> 
> No, it is not possible to do that reliably.
> 
> mdadm will tend to choose the first one it finds.  So if you add the
> best choices as spared first, and then add the poorer choices, it
> might be more likely to choose the one you want.
> 
No this does not work. I have added the spares in the following order:

   hda7 hde7 hda6 hde6

Here what /proc/mdstat says:

   Personalities : [raid0] [raid1] 
   md6 : active raid0 md3[0] md5[2] md4[1]
         215310528 blocks 64k chunks
         
   md1 : active raid1 hde3[1] hda3[0]
         4016128 blocks [2/2] [UU]
         
   md2 : active raid1 hde5[1] hda5[0]
         4007936 blocks [2/2] [UU]
         
   md3 : active raid1 hde6[2] hda6[3] hde7[4] hda7[5] sdd1[1] sda1[0]
         71770240 blocks [2/2] [UU]
         
   md4 : active raid1 sde1[1] sdb1[0]
         71770240 blocks [2/2] [UU]
         
   md5 : active raid1 sdf1[1] sdc1[0]
         71770240 blocks [2/2] [UU]
         
   md0 : active raid1 hde2[1] hda2[0]
         29197824 blocks [2/2] [UU]
         
   unused devices: <none>

So this looks just like what I want. But after boot it looks as follows:

   Personalities : [raid0] [raid1] 
   md6 : active raid0 md3[0] md5[2] md4[1]
         215310528 blocks 64k chunks
         
   md1 : active raid1 hde3[1] hda3[0]
         4016128 blocks [2/2] [UU]
         
   md2 : active raid1 hde5[1] hda5[0]
         4007936 blocks [2/2] [UU]
         
   md3 : active raid1 sdd1[1] sda1[0] hde7[2] hde6[3] hda7[4] hda6[5]
         71770240 blocks [2/2] [UU]
         
   md4 : active raid1 sde1[1] sdb1[0]
         71770240 blocks [2/2] [UU]
         
   md5 : active raid1 sdf1[1] sdc1[0]
         71770240 blocks [2/2] [UU]
         
   md0 : active raid1 hde2[1] hda2[0]
         29197824 blocks [2/2] [UU]
         
   unused devices: <none>

md3 is started via raid autodetect. How can I tell md the order of spares?

Thanks,
Holger
