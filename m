From: Doug Ledford <dledford@redhat.com>
Subject: Re: raid5 - failed disks - i'm confusing
Date: Mon, 04 Apr 2005 14:59:17 -0400
Message-ID: <1112641157.29559.22.camel@compaq-rhel4.xsintricity.com>
References: <Pine.LNX.3.96.1050401031922.31230A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050401031922.31230A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alvin Oga <aoga@mail.Linux-Consulting.com>
Cc: Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2005-04-01 at 03:22 -0800, Alvin Oga wrote:
> On Fri, 1 Apr 2005, Gordon Henderson wrote:
> > On Fri, 1 Apr 2005, Alvin Oga wrote:
> > 
> > > 	- ambient temp should be 65F or less
> > > 	and disk operating temp ( hddtemp ) should be 35 or less
> > 
> > Are we confusing F and C here?
> 
> 65F was for normal server room environment 
> 	( some folks use 72F for office )
> 
> and i changed units to 35C for hd operating temp vs 25C 
> 	- most of my ide disks run at under 30C
> 	- p4-2.xG cpu temps under 40C
> 
> > hddtemp typically reports temperatures in C. 35F is bloody cold!
> 
> nah ... i like my disks cold to the touch ... ( 2 fans per disks )

Just for the record, second guessing mechanical engineers with
thermodynamics background training and an eye towards differing material
expansion rates and the like can be risky.  This is like saying "Nah, I
like the engine in my car to run cold, so I use no thermostat and two
fans on the radiator."  It might sound like a good idea to you, but
proper cylinder to piston wall clearance is obtained at a specific
temperature (cylinder sleeves are typically some sort of iron or steel
compound and expand in diameter slower than the aluminum pistons when
heated to operating temperature, so the pistons are made smaller in
diameter at room temperature so that when both the sleeve and the piston
are at operating temperature the clearance will be correct).  Running an
engine at a lower temperature increases that clearance and can result in
premature piston failure.

As far as hard drive internals are concerned, I'm not positive whether
or not they are subject to the same sort of thermal considerations, but
just looking at the outside of a hard drive shows a very common case of
an aluminum cast frame and some sort of iron/steel based top plate.
These are going to expand at different rates with temperature and for
all I know if you run the drive overly cool, you may be placing undue
stress on the seal between these two parts of the drive (consider the
case of both the aluminum frame and the top plate having a channel for a
rubber o-ring, and until the drive reaches operating temp. the channels
may not line up perfectly, resulting in stress on the o-ring).

Anyway, it might or might not hurt the drives to run them well below
their designed operating temperature, I don't have schematics and
materials lists in front of me to tell for sure.  But second guessing
mechanical engineers that likely have compensated for thermal issues at
a given, specific common operating temperature is usually risky.  Most
people think "Heat kills" and therefore like to keep things as cool as
possible.  For mechanical devices anyway, it's not so much that heat
kills, as it is operating outside of the designed temperature range,
either above or below, that reduces overall life expectancy.  Keep your
drives from overheating, but don't try to freeze them would be my
advice.


-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


