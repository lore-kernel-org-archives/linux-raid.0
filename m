From: "Shaw, Marco" <marco.shaw@nbtel.nb.ca>
Subject: RE: 3 questions...
Date: Sun, 29 Sep 2002 19:57:41 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C65F89D1AC0BB54B865127151A24DA780BAD5C91@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> > tell kernel which devices to use for your root filesystem (if your 
> > root is on raid device), by using something like
> >   append="md=2,/dev/hda1,/dev/hdb1"
> 
> I have some partitions with the fd type in raid arrays but 
> would like to switch to the manual method you just described. 
> These partitions hold data I care about. Is it safe to change 
> the partition type:
>    - while the array is not active?
>    - while the array is active?

I would recommend to umount the array and stop it if you can.  The fd or default 83 (IIRC), is just a label on the disk, and won't destroy data.  I've more experience with labels on Solaris, and have done those "on-the-fly" with no affects though.

Remember (with RedHat Advanced Server anyway), you'd have to actually disable autodetection.  I'm still working on how it works because I'm still unclear whether this is a kernel feature, or just a result of init scripts.  An older RedHat reference:
http://www.redhat.com/support/resources/tips/raid/RAID-4.html

Marco
