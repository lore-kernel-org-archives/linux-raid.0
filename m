From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Mon, 14 Jan 2013 20:52:06 -0700
Message-ID: <201301142052.06390.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301141453.13819.thomas@fjellstrom.ca> <50F4B5E5.30809@hardwarefreak.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F4B5E5.30809@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Tommy Apel Hansen <tommyapeldk@gmail.com>, Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon Jan 14, 2013, Stan Hoeppner wrote:
> On 1/14/2013 3:53 PM, Thomas Fjellstrom wrote:
> >                                                             random  random   
> >                                                             bkwd   record  
> >                                                             stride
> >               
> >               KB  reclen   write rewrite    read    reread    read  
> >               write    read  rewrite     read   fwrite frewrite   fread 
> >               freread
> >         
> >         33554432    8192  124664  121973   524509   527971  376880 
> >         104357  336083    40088   392683   213941   215453  631122  
> >         631617
> > 
> > I assume that is to you liking?
> 
> Yes, much better.  Now, where is the output from the system you're
> comparing performance against?

I haven't been comparing it against my other system, as its kind of apples and 
oranges. My old array, on somewhat similar hardware for the most part, but 
uses older 1TB drives in RAID5.

Server hw:
Supermicro X9SCM-FO
Xeon E3-1230 3.2Ghz
16GB DDR3 1333mhz ECC
8 port IBM/LSI SAS/SATA HBA

NAS hw:
Intel S1200KP
Core i3-2120 3.3Ghz
16GB DDR3 1333mhz ECC
8 port IBM/LSI SAS/SATA HBA

Not the highest end hardware out there, but it gets the job done. I was 
actually trying to get less powerful hardware for the NAS, but I really 
couldn't find much that fit my other requirements (mini-itx server grade hw). 
Very limited selection of motherboards, most of which take socket 1155 cpus, 
and the selection of those that also take ECC ram is fairly limited as well.

> > As for the simple home server array, if it were so simple, it'd work out
> > of the box with no issues at all.
> 
> It is working.  And there are no issues, but for your subjective
> interpretation of the iozone data, assuming it is not working properly.

It is working. And I can live with it as is, but it does seem like something 
isn't right. If thats just me jumping to conclusions, well thats fine then. 
But 600MB/s+ reads vs 200MB/s writes seems a tad off.

> This is why benchmarks of this sort are generally only good for
> comparing one system to another.

I'm running the same iozone test on the old array, see how it goes. But its 
currently in use, and getting full (84G free out of 5.5TB), so I'm not 
positive how well it'll do as compared to if it was a fresh array like the new 
nas array.

Preliminary results show similar read/write patterns (140MB/s write, 380MB/s 
read), albeit slower probably due to being well aged, in use, and maybe the 
drive speeds (the 1TB drives are 20-40MB/s slower than the 2TB drives in a 
straight read test, I can't remember the write differences).

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
