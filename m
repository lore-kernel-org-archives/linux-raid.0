From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: 'Segmentation fault' after running 'mdadm --examine --brief --scan --config=partitions'
Date: Sun, 13 Mar 2005 12:48:07 -0500
Message-ID: <200503131748.j2DHmC505107@www.watkins-home.com>
References: <200503131322.29987.erik.wasser@iquer.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503131322.29987.erik.wasser@iquer.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Erik Wasser' <erik.wasser@iquer.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In the past, I have read:
--scan will cause mdadm to crash if there is no config file.
Don't use --scan, or create the mdadm.conf config file.

But you are using a much newer mdadm.  I don't know if this has been fixed
or not, I guess not.

The man page for mdadm has the details for the config file.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Erik Wasser
Sent: Sunday, March 13, 2005 7:22 AM
To: linux-raid@vger.kernel.org
Subject: 'Segmentation fault' after running 'mdadm --examine --brief --scan
--config=partitions'

Hello list,

I've got a problem here with the mdadm tools. I'm using on my system[1] 
the mdadm tools[2] and I just tried one of the examples of the manpage:

% mdadm --examine --brief --scan --config=partitions
Segmentation fault

I started up the ddd: in the routine 'load_conffile' the string "DEV 
partitions" will be passed to the routine 'devline'. And this routine 
pass this parameter to the macro 'dl_next' and I think (after seeing 
the definition of 'dl_next') this is brocken.

Can somebody confirm this bug? I don't know how to fix this so there is 
no patch in this mail sorry. B-(

[1] uname -a

Linux fuzz 2.6.10-gentoo-r6 #1 Sat Feb 5 09:56:14 CET 2005 i686 AMD 
Athlon(tm) XP 2800+ AuthenticAMD GNU/Linux

[2] Gentoo: sys-fs/mdadm-1.9.0-r1

-- 
So long... Fuzz
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

edesktop.xorg:373

On Sun, Mar 13, 2005 at 11:19:35AM -0500, Jon Smirl wrote:
> On Sun, 13 Mar 2005 23:04:59 +1100, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >=20
> > > AGP as it's currently used is pretty much pointless for software fa=
llbacks
> > > since reading from AGP memory is nearly as slow as reading from vid=
eo
> > > memory.
> >=20
> > Hrm.. I wouldn't expect _that_ slow. It's uncacheable, right, but sti=
ll
> > on a faster bus. Especially if we use it the way we do on ppc where w=
e
> > actually map the RAM pages directly instead of having processes go
> > through the GART.
>=20
> I asked at the Xdev conference if there were page table tricks that
> would work for accessing GART memory.  Everybody said no but I'm still
> wondering if there are any.
>=20
> For example the ppc has an instruction for flushing specific pages
> from cache, unlike the x86 where you can only flush everything.
>=20
> So on the ppc you could leave the GART memory mapped normally and
> cached. Do all of your fallback calculations, then flush the address
> range from cache. Now tell the GPU to go use it.
>=20
> Can't GART memory be normally cached RAM as long as we flush the cache
> before telling the GPU to use it?
>=20
> If you are doing fallback calculations in a 6MB buffer that is 1,500
> pages. Accessing all of this effectively flushes the data cache. Once
> you are done with it you probably don't want those pages in the cache
> anyway.

I don't understand why we have "GART memory" anyway. It's just main memor=
y=20
and I don't see any point going through the GART to access it with the=20
CPU. Only the graphics card needs to use the GART.

--=20
Ville Syrj=E4l=E4
syrjala@sci.fi
http://www.sci.fi/~syrjala/


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now.
http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
