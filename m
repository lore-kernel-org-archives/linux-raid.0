From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Best tool to partition Drives with new sector geometry - (WAS: Need
 Help with crashed RAID5 (that was rebuilding and then had SATA error on
 another drive))
Date: Sun, 18 Sep 2016 12:13:47 -0500
Message-ID: <e6180f36-f246-b4ad-ef53-8012e583b09e@gmail.com>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <215fd175-65b6-e24b-338f-0c44ae030573@websitemanagers.com.au>
 <CADDTLRBf9NPO6OuF4a3b+xffZgeZRqHRG+pJdPmbc9-Jat0HVQ@mail.gmail.com>
 <d6d3fe0d-3f9f-985f-9bfb-051428cf221b@websitemanagers.com.au>
 <57BBDA5B.3020706@gmail.com> <57BBDC15.5030301@gmail.com>
 <b8c6a380-7e6a-fda9-5834-b85271b26892@websitemanagers.com.au>
 <57BC61F7.8070102@gmail.com>
 <aca4e83f-9a3f-c200-7c16-3b5d9df52c1e@websitemanagers.com.au>
 <57BE450B.4030700@gmail.com>
 <56e86db5-456d-e9c1-339d-ba8903fe5dde@websitemanagers.com.au>
 <57BE52BC.6040908@gmail.com>
 <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
 <57BF9965.1020403@gmail.com> <57C0856D.8050209@youngman.org.uk>
 <57C32D8E.9030102@gmail.com>
 <3b008fb0-1fb3-f12f-d973-3657de6e6923@websitemanagers.com.au>
 <57C38EF5.7020005@gmail.com> <57C41A47.5050506@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57C41A47.5050506@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In a followup question to my arrays, I have a question about the new WDs with the larger sector size geometry but support 512B sectors.

I bought some WD Reds (WD10EFRX) drives.

When I let the linux "Disk Utility" (palimpest <- who the heck named that anyway?) do the RAID management with a new drive, it partitions on cyls and not sectors.

So it makes a partition and then complains to me it's off by 512bytes which could affect performance.

Gee. Thanks.

So I can use g/parted -- or fdisk....

but I thought I'd get any suggestions for the preferred tool and any pitfalls to watch out for.

Thanks,

 -Ben

