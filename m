From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: Impact of missing parameter during mdadm create
Date: Sat, 5 Mar 2011 09:47:58 -0500
Message-ID: <BAY148-w429D7C51F07A94EB200573EFC50@phx.gbl>
References: <BAY148-w59357147C486E15E514067EFC50@phx.gbl>,<1299307055.4999.8.camel@tankquad>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1299307055.4999.8.camel@tankquad>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linuxraid@kendrummond.com
List-Id: linux-raid.ids


> On Sat, 5 Mar 2011 16:37:35 +1000 <linuxraid@kendrummond.com> wrote:
>=20
> > On Fri, 2011-03-04 at 23:22 -0500, Mike Viau wrote:
> >=A0
> > Attached HOST_SYSLOG.txt is the _complete_ syslog after a system re=
boot showing only 2 drives are assembled automatically on boot, and the=
 array is degraded.
> >=20
> >=20
>=20
> OK, I guess I should have thought of this before, your syslog shows t=
hat
> sdd is attached as a USB device and is not discovered until after md0
> has been assembled (using all the devices available at the time).  I'=
m
> not sure how you would make md auto assembly wait until after your US=
B
> device has been discovered.  Hopefully someone else here can provide
> some advice, although it's not strictly a linux-raid issue there are
> quite a few helpful people here.
>=20
> I'm pretty sure if you replaced the USB device with another SATA devi=
ce
> things would work as you expected. Another alternative may be to not
> have that array auto assembled but wait and assemble after the boot i=
s
> finished, this could probably be scripted.
>=20
> Ken.
>=20

Well that about explains it, thanks for your help and time :)
I am going to mark this thread as [solved] for now, the issue was not w=
ith the missing=A0parameter, but with the drive missing being connected=
 to the usb bus. When I get a moment later today I'll search around to =
see what others in this situations have done. If all else fails and I d=
on't find anything or I just find the quick and dirty script fixes, the=
n I will post a new thread looking for suggestions.
I guess I could open up my hard drive enclosure too, but in doing so I'=
d be voiding the=A0warranty=A0I have left on it.
Regardless thanks again Ken!

-M 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
