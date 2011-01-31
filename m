From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID HDDs spin up sequence
Date: Mon, 31 Jan 2011 23:23:48 +0100
Message-ID: <20110131222348.GA15912@lazy.lzy>
References: <20110131201823.GA15704@lazy.lzy>
 <AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 31, 2011 at 07:09:24PM -0200, Roberto Spadim wrote:
> you psu must be dimensioned to work with everythink at full work load
> (it=B4s a real production NAS right?! not a test)
> your SAS/IDE/SATA controller and HDD manual should be checked
> how hdd wake up? one command (read/write) over sata/sas/ide channel w=
ake it up?
> on linux raid we have a read algorithm and a write algorithm
> if a raid1 write occur all disks will wake up
> if a raid1 (raid0 or another) read occur only the disk will wake up
>=20
> but check you SATA/IDE/SATA controller, how it wake up your disk, and
> how you hdd wake up

Hi, thanks for the answer, unfortunately I was
hoping to have made myself clear enough.

=46irst of all, it is a RAID-6, so let's say that's
already decided by requirements. With SATA HDDs.

Second, the question was exactly about how the HDDs
are waked up. This is a SW issue, trying with normal
setups, i.e. a couple of disks, it is possible to
send them to sleep (hdparm -y /dev/hdX) and the wake
them up by a simple access.
I had no opportunity to check this with a RAID-5/6,
so I was asking if anyone knows.

=46inally, in order to be power efficient, the PSU,
assuming something like an 80 Plus Gold, should work
at not less than 20% of the nominal power, otherwise
(according to some reviews), the efficiency drops far
below the 80%~90% declared by the 80 Plus standard
(which is measured at 20%, 50% and 100% of the maximum
specified power).
It seem it gets easily around 40%~50%.
So, the PSU must be somehow under dimensioned for the
spin up of 10 HDDs, which seem to require a possible
30W*10=3D300W (some nasty HDDs seem to require 30W, in
this situation) only for the storage.

If the HDDs spin up one after the other, then the peak
consumption is only 30W, which might allow a lower
power PSU, in contrast with the requirement to provide
300W alone for the spin up.

So, back to the original question, if a 10 HDDs RAID-6
is in standby, how do the single HDD will be waked up,
in case of access? Of course, a quite larger access,
i.e. some GiB of data.

Thanks again,

bye,

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
