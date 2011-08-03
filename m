From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Wed, 03 Aug 2011 02:13:18 -0500
Message-ID: <4E38F50E.6050406@hardwarefreak.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Scheiner <blue@aquarat.za.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/27/2011 7:16 AM, Aaron Scheiner wrote:

> The drive on which the OS sat died a few days ago, so I installed a
> new OS drive and then installed Ubuntu Server on it.
> On reboot the machine hung on a black screen with a white flashing
> cursor. So I went back into the Ubuntu Setup and installed grub to all
> of the drives in the raid array (except two) [wow, this was such a
> stupid move].
> 
> I then rebooted the machine and it successfully booted into Ubuntu
> Server. I set about restoring the configuration for the raid array...
> only to be given the message "No Superblock Found" (more or less).
> Each element in the array was used directly by mdadm (so /dev/sda, not
> /dev/sda1).
...

I should have mentioned these thoughts previously, but often folks on
this list get tired of hearing it over and over, similar to Mom saying
"clean your room" or road signs every few miles telling you to "buckle
up".  People get tired of it, but there's a good reason for it: to
prevent future heartache.

Now that you're seen first hand how fragile Linux RAID can be in some
circumstances in the hands of less than expert users, you may want to
consider taking measures to prevent the consequences of this kind of
thing in the future:

1.  Make regular backups of your data and configuration files
    -use flash pen drive for the config files
    -use whatever you can afford for data files
    -if you can't afford to backup 16TB, use DVD-R for important files
     and sacrifice the rest
2.  Use kernel supported hardware RAID everywhere if you can afford it
3.  At minimum use a bootable hardware RAID card with RAID1 drives

In this case #3 would have saved your bacon.  One possible Linux
compatible solution would be the following:

Qty 1:  http://www.newegg.com/Product/Product.aspx?Item=N82E16816116075
Qty 2:  http://www.newegg.com/Product/Product.aspx?Item=N82E16820167062
 and
Qty 1:  http://www.newegg.com/Product/Product.aspx?Item=N82E16817996013
 or
Qty 1:  http://www.newegg.com/Product/Product.aspx?Item=N82E16817986003
to house the SSDs, depending on what free bays you have.

Mirror the two Intel Enterprise SSDs with the controller and install
Ubuntu on the RAID device.  The mainline kernel supports the 3Ware 9650
series so it should simply work.  You'll only have 20GB but that should
be more than plenty for a boot/root filesystem drive.  This is the least
expensive hardware RAID1 boot setup I could piece together but at the
same time the fastest.  This will run you ~$435-$460 USD.  I have no
idea of cost or availability of these in the UK.  For about $20 USD more
per drive you could use the 500GB Seagate Constellation Enterprise 2.5"
7.2k drives:
http://www.newegg.com/Product/Product.aspx?Item=N82E16822148711

If you must substitute, simply make sure you get an "enterprise" type
drive/SSD as they have TLER support and other firmware features that
allow them to play nice with real RAID cards.

-- 
Stan
