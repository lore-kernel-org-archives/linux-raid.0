From: "Petriz, Pablo" <ppetriz@siscat.com.ar>
Subject: RE: Promise SX6000 is a POS.
Date: Wed, 7 Apr 2004 13:29:09 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1CEC5A75042ED51180E300A024E99257AD8227@zeus.sc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'Jason C. Leach'" <Jason.Leach@jsthrower.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We have a similar configuration (SX6000) and for the same purpose, store GIS
files: shape files, tifs and jpg (not databases), it's like an image file
repository. 

And we have seen an even lower perfomance than you.

I'll tell you an overview of our configuration, and for the fine tuning
numbers (perf tests, fs conf, blocks, stripes, all the raid stuff) please
wait till next week (my sysadmin is on vacation).

MAIN SERVER
Intel Xeon 2.4Ghz on a SE7501BR2 motherboard with 1GB RAM and a Seagate 40GB
IDE for the RedHat Linux 8 Kernel 2.4.18-14 attached to a Promise SX8000
tower with 8 Maxtor MaxLineII 300GB 5400RPM (6 on RAID5, 2 hotspare)

BACKUP SERVER
Intel Xeon 2.4Ghz on a SE7501BR2 motherboard with 1GB RAM and a Seagate 40GB
IDE for the RedHat Linux 9 Kernel 2.4.20-8 plus a Promise SX6000 with 5
internal Maxtor MaxLineII 300GB 5400RPM (all on RAID5 on 1 EXT3 FS)

The fact is that the main server isn't working yet (that's another story...)
but we have the backup server working. We are looking for storage capacity
over performance, that makes the decision between 300GB 5400RPM over 250GB
7200RPM... but what about the SX6000 performance? We expect a little
better...

We are really newbies in RAID stuff, and our goal was to design a reliable
near 2TB storage + bkup with a uSs15.000 budget and here, in Argentina where
it's not easy to get specific products and support.

That's an overview of our situation, and i'm really interested in share our
experience to help others and to make this work the best we can. So, as i
said, wait till next week for the specific information.

Thanks,


PABLO



> -----Mensaje original-----
> De: Jason C. Leach [mailto:Jason.Leach@jsthrower.com]
> Enviado el: viernes 2 de abril de 2004 02:53
> Para: linux-raid@vger.kernel.org
> Asunto: Promise SX6000 is a POS.
> 
> 
> Linux-Raid:
> 
> I have a Promise SX6000 RAID card and on it an 1Tb RAID-5 
> array (6*200G 
> WD2000 ATA disks 7500rmp).  I am using Debian Woody with the 2.4.19 
> Kernel on a AMD AthelonXP +2500 system. I am using the Promise driver 
> downloaded and compiled from there website.
> 
> I am getting about 3.3Meg/sec from the array to an EIDE disk (segate 
> barracuda ATA). While from the Array to the Array I get about  
> 4.1Meg/sec; copying 200G is an overnight plus job for sure. 
> To me this 
> is stupid slow, and I must be doing something wrong. Even if 
> the Promise 
> card is the slowest one available (3Ware, Promise, Adaptek) it can't 
> really be *this* slow: this card should not even be on the market at 
> this speed.  All the while my system load average is about 1.5-2.  Is 
> this Linux? Does it really run this slow under Windows as 
> well? Should I 
> be using i2o or some other driver? Perhaps the array is just 
> too large?
> 
> PS: I get no errors, and the card is on it's own interrupt 
> with a full 
> 128MB cache.
> 
> Thanks,
> Jason.
> 
> 
> -- 
> Jason C. Leach
> IT Manager
> J.S. Thrower & Associates Ltd.
> Phone: (250) 314-0875 Fax (250) 314-0871
> email: jason.leach@jsthrower.com
> http://www.jsthrower.com
> 
> 
