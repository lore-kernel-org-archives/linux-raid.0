From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Busted disks caused healthy ones to fail
Date: Tue, 14 Dec 2004 17:13:32 -0500
Message-ID: <200412142213.iBEMDb911110@www.watkins-home.com>
References: <20041214214946.GA23973@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041214214946.GA23973@jim.sh>
Sender: linux-raid-owner@vger.kernel.org
To: 'Jim Paris' <jim@jtan.com>, 'Brad Campbell' <brad@wasp.net.au>
Cc: comsatcat@earthlink.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If all of my disks were to start at the same time (assuming I had 14), they
would require 483 watts while starting up!

My disks use 2.5 amps on startup.  On the 12V line.  But use .98 amps when
idle.  And .90 amps on the 5V line.  I have my system to delay the starting
of the disks based on SCSI ID, so only one starts at a time.  If your disks
start at the same time, then OUCH!  How can it work?

You should find the specs on your disks and do some math just to be sure.

If you want to compare, specs for my disks:
http://www.seagate.com/support/disc/specs/scsi/st118202lc.html

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jim Paris
Sent: Tuesday, December 14, 2004 4:50 PM
To: Brad Campbell
Cc: Guy; comsatcat@earthlink.net; linux-raid@vger.kernel.org
Subject: Re: Busted disks caused healthy ones to fail

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
http://www.newegg.com/app/viewproductdesc.asp?submit=Go&description=N82E1681
7103445
Note how it's +12V output is rated for only __15 amps__.

Your numbers might differ a bit.  But it is NO surprise that your
drives are failing.  The surprising part is that they and your power
supply have worked this long.

-jim
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

