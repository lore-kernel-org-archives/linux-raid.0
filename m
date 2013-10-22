From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Linux MD? Or an H710p?
Date: Tue, 22 Oct 2013 11:43:45 -0500
Message-ID: <5266AB41.8020509@hardwarefreak.com>
References: <526328AE.2020908@gmail.com> <21093.14265.261728.755087@quad.stoffel.home> <5265C89A.4000908@gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5265C89A.4000908@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/21/2013 7:36 PM, Steve Bergman wrote:
> First of all, thank you Stan, Mikael, and John for your replies.
> 
> Stan,
> 
> I had made a private bet with myself that Stan Hoeppner would be the
> first to respond to my query. And I was not disappointed. In fact, I was
> hoping for advice from you. 

No need to bet.  Just assume.  ;)

> We're getting the 7 yr hardware support
> contract from Dell, 

Insane, 7 years is.  Exist then, Dell may not.  Clouded, Dell's future is.

> and I'm a little concerned about "finger-pointing"
> issues with regards to putting in a non-Dell SAS controller. 

Then use a Dell HBA.  They're all LSI products anyway, and have been
since the mid 90s when Dell re-badged their first AMI MegaRAID cards as
"Power Edge RAID Controller".

The PERC H310 is a no-cache RAID HBA, i.e. a fancy SAS/SATA HBA with
extremely low performance firmware based RAID5.  Its hardware RAID1/10
performance isn't bad, and allows booting from an array device sans teh
headaches of booting md based RAID.  It literally is the Dell OEM LSI
9240-8i, identical but for Dell branded firmware and the PCB.  You can
use it it JBOD mode, i.e. as a vanilla SAS/SATA HBA.  See page 43:

ftp://ftp.dell.com/manuals/all-products/esuprt_ser_stor_net/esuprt_dell_adapters/poweredge-rc-h310_User%27s%20Guide_en-us.pdf

You can also use it in mixed mode, configuring two disk drives as a
hardware RAID1 set, and booting from it, and configuring the other
drives as non-virtual disks, i.e. standalone drives for md/RAID use.
This requires 8 drives if you want a 6 disk md/RAID10.  Why, you ask?
Because you cannot intermix hardware RAID and software RAID on any given
drive, obviously.

Frankly, if you plan to buy only 6 drives for a single RAID10 volume,
there is no reason to use md/RAID at all.  It will provide no advantage
for your stated application, as the firmware RAID executes plenty fast
enough on the LSISAS2008 ASIC of the H310 to handle the
striping/mirroring of 6 disks, with no appreciable decrease in IOPS.
Though for another $190 you can have the H710 with 512MB NVWC.  The
extra 512MB of the 710P won't gain you anything, yet costs an extra $225.

The $190 above the H310 is a great investment for the occasion that your
UPS takes a big dump and downs the server.  With the H310 you will lose
data, corrupting users' Gnome config files, and possibly suffer
filesystem corruption.  The H710 will also give a bump to write IOPS,
i.e. end user responsiveness with your workload.

All things considered, my advice is to buy the H710 at $375 and use
hardware RAID10 on 6 disks.  Make /boot, root, /home, etc on the single
RAID disk device.  I didn't give you my advice in my first reply, as you
seemed set on using md.

> Network
> card? No problem. But drive controller? Forgive me for "white-knuckling"
> on this a bit. But I have gotten an OK to order the server with both the
> H710p and the mystery "SAS 6Gbps HBA External Controller [$148.55]" for

Note "External".  You don't know what an SFF8088 port is.  See:
http://www.backupworks.com/productimages/lsilogic/lsias9205-8e.jpg

You do not plan to connect an MD1200/1220/3200 JBOD chassis.  You don't
need, nor want, this "External" SAS HBA.

> which no one at Dell seems to be able to tell me the pedigree. So I can

It's a Dell OEM card, sourced from LSI.  But for $150 I'd say it's a 4
port card, w/ single SFF8088 connector.  Doesn't matter.  You can't use it.

> configure both ways and see which I like. 

Again, you'll need 8 drives for the md solution.

> I do find that 1GB NV cache
> with barriers turned off to be attractive.

Make sure you use kernel 3.0.0 or later, and edit fstab with inode64
mount option, as well as nobarrier.

> But hey, this is going to be a very nice opportunity for observing XFS's
> savvy with parallel i/o. And I'm looking forward to it. 

Well given that you've provided zero detail about the workload in this
thread I can't comment.

> BTW, it's the
> problematic COBOL Point of Sale app 

Oh God... you're *that* guy?  ;)

> that didn't do fsyncs that is being
> migrated to its Windows-only MS-SQL version in the virtualized instance

Ok, so now we have the reason for the Windows VM and MSSQL.

> of Windows 2008 Server. At least it will be a virtualized instance on
> this server if I get my way. 

Did you happen to notice during your virtual machine educational
excursions that fsync is typically treated as a noop by many
hypervisors?  I'd definitely opt for a persistent cache RAID controller.

> Essentially, our core business is moving
> from Linux to Windows in this move. C'est la vie. I did my best. NCR won.

It's really difficult to believe POS vendors are moving away from some
of the most proprietary, and secure (if not just obscure) systems on the
planet, for decades running System/36, AT&T SYS V, SCO, Linux, and now
to... Windows?

-- 
Stan

