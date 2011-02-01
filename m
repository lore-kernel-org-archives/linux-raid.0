From: <brian.foster@emc.com>
Subject: RE: RAID HDDs spin up sequence
Date: Tue, 1 Feb 2011 08:55:41 -0500
Message-ID: <9EBB77E762A6744BACE68EDD6A4796990129EC0E@MX31A.corp.emc.com>
References: <20110131201823.GA15704@lazy.lzy>
 <AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
 <20110131222348.GA15912@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131222348.GA15912@lazy.lzy>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: piergiorgio.sartor@nexgo.de, roberto@spadim.com.br
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Piergiorgio Sartor
> Sent: Monday, January 31, 2011 5:24 PM
> To: Roberto Spadim
> Cc: Piergiorgio Sartor; linux-raid@vger.kernel.org
> Subject: Re: RAID HDDs spin up sequence
>=20
> On Mon, Jan 31, 2011 at 07:09:24PM -0200, Roberto Spadim wrote:
> > you psu must be dimensioned to work with everythink at full work lo=
ad
> > (it=B4s a real production NAS right?! not a test)
> > your SAS/IDE/SATA controller and HDD manual should be checked
> > how hdd wake up? one command (read/write) over sata/sas/ide channel
> wake it up?
> > on linux raid we have a read algorithm and a write algorithm
> > if a raid1 write occur all disks will wake up
> > if a raid1 (raid0 or another) read occur only the disk will wake up
> >
> > but check you SATA/IDE/SATA controller, how it wake up your disk, a=
nd
> > how you hdd wake up
>=20
> Hi, thanks for the answer, unfortunately I was
> hoping to have made myself clear enough.
>=20
> First of all, it is a RAID-6, so let's say that's
> already decided by requirements. With SATA HDDs.
>=20
> Second, the question was exactly about how the HDDs
> are waked up. This is a SW issue, trying with normal
> setups, i.e. a couple of disks, it is possible to
> send them to sleep (hdparm -y /dev/hdX) and the wake
> them up by a simple access.
> I had no opportunity to check this with a RAID-5/6,
> so I was asking if anyone knows.
>=20
> Finally, in order to be power efficient, the PSU,
> assuming something like an 80 Plus Gold, should work
> at not less than 20% of the nominal power, otherwise
> (according to some reviews), the efficiency drops far
> below the 80%~90% declared by the 80 Plus standard
> (which is measured at 20%, 50% and 100% of the maximum
> specified power).
> It seem it gets easily around 40%~50%.
> So, the PSU must be somehow under dimensioned for the
> spin up of 10 HDDs, which seem to require a possible
> 30W*10=3D300W (some nasty HDDs seem to require 30W, in
> this situation) only for the storage.
>=20
> If the HDDs spin up one after the other, then the peak
> consumption is only 30W, which might allow a lower
> power PSU, in contrast with the requirement to provide
> 300W alone for the spin up.
>=20
> So, back to the original question, if a 10 HDDs RAID-6
> is in standby, how do the single HDD will be waked up,
> in case of access? Of course, a quite larger access,
> i.e. some GiB of data.

We have a similar situation with our Iomega NAS products. We had a fair=
ly crude locking mechanism implemented at the SCSI level that suits our=
 needs to support staggered spin up. As indicated previously, we find t=
hat a 1 or 2 second delay between spin ups modulates the current draw e=
nough such that we don't run into problems. We use this in conjunction =
with MD without much of a problem.

I'm not sure that the code as implemented is appropriate for mainline i=
nclusion (and I'm not going to post it directly), but FYI the patches a=
re included in the open source tarball that is made available on the su=
pport section of the iomega.com website (hint: check out the ix12 suppo=
rt & downloads section).

Brian

>=20
> Thanks again,
>=20
> bye,
>=20
> --
>=20
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
