From: "Alexander Economou" <aecon@gnet.gr>
Subject: Re: SATA Controller
Date: Tue, 10 Aug 2004 10:50:13 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40381.212.251.31.59.1092124213.squirrel@mail.gnet.gr>
References: <20040809145342.M63373@contactbda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040809145342.M63373@contactbda.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

0                                                                                                                                                  

 If you plan on using software raid it would be a nice idea to use a 2.6.x
kernel in case you are using a 2.4.x kernel.There is a huge speed diff in
data transfer between those 2 kernel versions.
 I have installed a couple of s150 tx4 and i can say that they work fine.I
also noticed that there is support for this controller in the low level
driver section(scsi) in 2.4.27 kernel.If this doesnt work out (wich i
doubt it)try downloading the driver from promise.com.
 One thing i dont understand is why buy raid controllers and do software
raid(if that is what you ment)

> All,
>
> I am thinking of going with the following SATA PCI controller (non raid)
> to replace my 3ware SATA controller (only
> using JBOD but thats another story).  Any comments on linux support /
> issues / other controllers you have luck with.
> I am planning on using software raid with 3 of these cards and 10 250G WD
> SATA disks.
>
> Thanks
> Jim
>
> PROMISE PCI to SATA Controller Card, Model "SATA150 TX4" -OEM
>
> Model# Sata150 TX4
> Item # N82E16816102013
>
> Specifications:
> Ports: 4x Serial ATA/150
> OS Support: Windows 98/Me/NT4/2000/XP; RedHat 7.3/8.0; SuSE 7.3/8.0
> Feature: Bus mastering offloads data I/O handling from host CPU; CRC
> error-checking of Serial ATA and Ultra ATA drives for data reliability
> during transfers; Data Transfer Rate:150MB/sec with Serial ATA/150 drives,
> 133MB/sec with Ultra ATA/133 drives, 100MB/sec with Ultra ATA/100 drives;
> 32-bit 33/66MHz PCI bus; PCI 2.3 compliant
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Alexander Economou
GNET NOC
