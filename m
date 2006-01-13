From: <bhess@patmedia.net>
Subject: Re Re USB Raid
Date: Fri, 13 Jan 2006 14:48:02 -0500
Message-ID: <20060113195010.2FAF435CE19@mxo1.broadbandsupport.net>
Reply-To: bhess@patmedia.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: ross@jose.lug.udel.edu, david@dgreaves.com, linux-raid@vger.kernel.org
Cc: bhess@patmedia.net
List-Id: linux-raid.ids

All=0D
Thank you for the responses.  =0D
=0D
When I wrote the initial email I left out detail in order to keep the t=
hings short.=0D
=0D
To address a few of the concerns and suggestions.=0D
=0D
The construction of the =93Disk Farm=94 will be as needed starting =0D
with two 200G dirves raid 1 that will be NFS and Samba advertised =0D
and two 160G drives raid 1 that will be separately advertised.  =0D
I picked these up yesterday.  In the future raid 1 pairs will be =0D
added as required and offered as individual resources that I will manag=
e.  =0D
Other members of my family tend to use disk space and I need to control=
=0D
whos computer can consume what.   I am by far the biggest culprit.  =0D
=0D
One other point, that I will test, is in the event of a server or =0D
disk failure I can disconnect the good drive and connect it to =0D
another system and manually mount it to retrieve the data =0D
instead of replacing the failed drive and rebuilding the raid.  =0D
This is why I am using raid 1 and not raid 5.  =0D
ANY COMMENT ON THIS appreciated.  =0D
=0D
160G ATA drives can be found around here for $39.99 on =0D
sale and $200G for $89 any day of the week.  =0D
=0D
Each drive in a pair will be connected through separate =0D
USB ports on the server and USB Hubs.  This pushes =0D
the single point of failure back to the server on one end =0D
the power supply in the disk farm on the other.=0D
=0D
I am using USB to IDE cables without individual power =0D
supplies.  All of the drives will be mounted in a 2U case =0D
with a PC Power and Cooling supply with an opto-isolater =0D
controlling the supply turn on slaved to the server=92s 5 volt =0D
supply.  Unused outputs on the   PC Power and Cooling =0D
supply that require a minimum load will be terminated with =0D
resistors.  As I add disks the spin up load on the supply =0D
will be measured to stay in spec.  The nice thing with =0D
the USB connection is I can start another farm in another =0D
case, within reason.  The number 14 for total disk count =0D
is limited by the case size and more importantly the =0D
thermal management inside the case.  A serial connected =0D
temperature probe located near the air exit port will be =0D
monitored by the server.  =0D
=0D
Professionally I use Sun Solaris on high end machines =0D
and am switching to RedHat from Unixware for the low end.  =0D
I run Oracle on both.  Personally I use the CENTOS, which =0D
is where the disk farm will be attached.  A second CENTOS =0D
system will take over by Oracle database from Unixware.  =0D
I picked CENTOS because I only have time to port Unixware =0D
to one other OS and CENTOS is RedHat.  RedHat  was =0D
selected purely based on support availability for the OS/Oracle combina=
tion.   =0D
=0D
=46urther suggestions or discussion are welcome=0D
=0D
Bill Hess=0D
=0D
bhess@patmedia.net=0D
=0D
=0D
=0D
=0D
=0D
=0D
On Thu Jan 12 12:20 , ross@jose.lug.udel.edu (Ross Vandegrift) sent:=0D
=0D
    On Thu, Jan 12, 2006 at 11:16:36AM +0000, David Greaves wrote:=0D
    > ok, first off: a 14 device raid1 is 14 times more likely to lose =
*all*=0D
    > your data than a single device.=0D
=0D
    No, this is completely incorrect. Let A denote the event that a sin=
gle=0D
    disk has failed, A_i denote the event that i disks have failed.=0D
    Suppose P(A) =3D x. Then by Bayes's Law the probability that an n d=
isk RAID=0D
    will lose all of your data is:=0D
=0D
    n_1 =3D P(A) =3D x=0D
    n_2 =3D P(A_2) =3D P(A) * P(A_1 | A) =3D x^2=0D
    n_3 =3D P(A_3) =3D P(A) * P(A_2 | A) =3D x^3=0D
    ...=0D
    n_i =3D P(A_i) =3D P(A) * P(A_{i-1} | A) =3D x^i=0D
=0D
    ie, RAID1 is expoentially more reliable as you add extra disks!=0D
=0D
    This assumes that disk failures are independant - ie, that you=0D
    correctly configure disks (don't use master and slave on an IDE=0D
    channel!), and replace failed disks as soon as they fail.=0D
=0D
    This is why adding more disks to a RAID1 is rare - x^2 is going to =
be=0D
    a really low probability! It will be far, far more common for=0D
    operator error to break a RAID than for both devices to honestly fa=
il.=0D
=0D
    -- =0D
    Ross Vandegrift=0D
    ross@lug.udel.edu=0D
=0D
    "The good Christian should beware of mathematicians, and all those =
who=0D
    make empty prophecies. The danger already exists that the mathemati=
cians=0D
    have made a covenant with the devil to darken the spirit and to con=
fine=0D
    man in the bonds of Hell."=0D
    --St. Augustine, De Genesi ad Litteram, Book II, xviii, 37=0D
=0D
=0D
ross@jose.lug.udel.edu (Ross Vandegrift)=0D
David Greaves <david@dgreaves.com>=0D
bhess@patmedia.net, linux-raid@vger.kernel.org=0D
=0D
=0D
=0D
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
