From: Jim Paris <jim@jtan.com>
Subject: Re: Busted disks caused healthy ones to fail
Date: Tue, 14 Dec 2004 16:49:46 -0500
Message-ID: <20041214214946.GA23973@jim.sh>
References: <200412141523.iBEFN4909947@www.watkins-home.com> <41BF4967.9000801@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41BF4967.9000801@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Guy <bugzilla@watkins-home.com>, comsatcat@earthlink.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> It's not that hard.
> I have 4 drives loaded in the rear bays and 2 x 5 Way SATA Hotswap bays in 
> the 6 front 5.25 inch bays. 14 Drives. And yes, they are on a single 420w 
> PSU along with the motherboard, Athlon XP 2600+. and 5 80mm fans. Not much 
> else though.

!!!!!!  Holy crap!

Let's pick a random typical hard drive, a Seagate 120GB SATA:
http://www.mittoni.com.au/catalog/product_info.php/products_id/1690
It lists maximum current draw as 2.8 A on the +12V line.
Multiply that by 14 drives and we get __39.2 amps__.

Now let's pick a random 420W power supply:
http://www.newegg.com/app/viewproductdesc.asp?submit=Go&description=N82E16817103445
Note how it's +12V output is rated for only __15 amps__.

Your numbers might differ a bit.  But it is NO surprise that your
drives are failing.  The surprising part is that they and your power
supply have worked this long.

-jim
