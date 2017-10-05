From: NeilBrown <neilb@suse.com>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Fri, 06 Oct 2017 10:39:50 +1100
Message-ID: <87mv5517w9.fsf@notabene.neil.brown.name>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org> <871sn78pzt.fsf@notabene.neil.brown.name> <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se> <874ls0s7un.fsf@notabene.neil.brown.name> <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se> <87lgkr3fgj.fsf@notabene.neil.brown.name> <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com> <87d162380v.fsf@notabene.neil.brown.name> <4bc99226-0843-351b-dca6-7d0a083de925@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4bc99226-0843-351b-dca6-7d0a083de925@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 05 2017, Artur Paszkiewicz wrote:

> On 10/04/2017 11:41 PM, NeilBrown wrote:
>> On Wed, Oct 04 2017, Artur Paszkiewicz wrote:
>>=20
>>>
>>> Also, our customers are asking specifically for an option to "hide" the
>>> member drives. Making it impossible to write to the devices is ok, but
>>> they would like to see only the md device, "like hardware raid". One of
>>> the reasons is that some monitoring or inventory scan applications treat
>>> md arrays and their components as separate storage devices. They should
>>> probably modify their software but maybe that's not possible.
>>=20
>> What exactly is meant by "hide".  How, exactly, does this software scan
>> all devices?  /proc/partitions? /sys/block? /sys/class/block?
>> /dev/disks?  All of the above.
>>=20
>> Modifying their application *must* be on the table, else modify the
>> kernel is *not* on the table.  I'm certainly open to enhancing the
>> kernel so that it is easy to skip a particular class of devices, but if
>> their application chooses to ignore the information the kernel provides,
>> then the fact that the application doesn't work is their problem, not
>> ours.
>>=20
>>=20
>>>
>>> I've been experimenting with different solutions and here is a patch
>>> that allows to "hide" disk devices and their partitions by writing to a
>>> sysfs attribute. It removes the device nodes (on devtmpfs), links in
>>> /sys/block/ and removes the devices from the block class list, so they
>>> won't be included in places like /proc/partitions, /sys/class/block/,
>>> lsblk and so on. The device's "real" sysfs directory under /sys/devices/
>>> is still available, also the links in /sys/dev/block/ are preserved.
>>> Applications like mdadm can use this to hide/unhide their component
>>> devices.
>>=20
>> Can you confirm that this addresses the customer problem?  Do you know
>> which of these lists their code looks at?
>
> Yes, this is what they asked for. I know that at least /proc/partitions
> and /sys/class/block are used. But this is not a single customer (or
> application) case, this keeps coming up again and again... Of course
> educating users about the specifics of md and that not hiding the drives
> is actually an advantage always comes first. Some get it and would be ok
> with just blocking write access to the drives, but others really want
> this hiding approach.
>

Hmmm.. interesting that it is multiple applications.
Given that both md and dm have been around for years and have layered on
top of exiting devices without hiding them, it is hard to see how these
applications have not run into problem before.

There is some precedent for hiding things from /proc/partitions.
removable devices like CDROMs are hidden, and you can easily hide
individual devices by setting GENHD_FL_SUPPRESS_PARTITION_INFO.
We might be able to get that through.  It is certainly worth writing a
patch and letting people experiment with it.

Removing things from /sys/class/block is much less likely to be
acceptable.  Code really shouldn't be digging around in there without
knowing what it is doing.  It should be trivial to ignore any entry in
/sys/class/block where the 'holders' directory is not empty, and that
should achieve the goal.  For users of /sys/class/block I think you
really need to push back on the customers and tell them their
application is broken.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnWwscACgkQOeye3VZi
gbme1w//f0e+iNyArBxedzV4f/CQPUoPjwYu40rtvSRjvDVFMlYUEdHCDIqMd4uW
yDkGEe4pjO8EgXgXF+T8ZtD8DOm7mofT0kRnmTLPXJ9HZhwTE+y8ym5s9jU/M46g
63vLRg+yE/qNiQs0TyT8oBQyyDTJtADpjSHp1ICXIbpM2YPdmnkBmK73PQPzg7Gk
jT2iMcmjIR924z7ImJfnS4AeYOpPFOIFwu5xWHn7WprWMAT10tYFQayki+tQ444k
TDxeUYAxrmyjSdlbshaLb9F4dQqtg97KXS/Eo4v9VQxSQtnvPf63Wi0S+PM4/zl8
KTvl9hFMHBML+9CCi9vFWkt6idZ1Jep9mBAQ4SajvsWbc1RXochetvCS6gTEs6x1
aitrLZJMUbkLU0DgtFSgh7PG5nvduntYXTtNP4xFwegfgfgTLjMpp8/sxLaPlAC7
ljharFpWSKLPJkkToxi96x1e6D0sDNzj8lGLhA6QGKRCNp+fplK3Zmjx2QJFScSn
gtJiu+KVbF9rtXbEOoo6fxv4xrigYF+MGopDN/TKPjm8NE3jpGckbZTZMJE0qU3I
oBixMuQpqHY8g6f2RNDVFp2e84LtZvfvigFj3549nS/wBWdvnoD8he81wG/KwXYr
DOE/LIjzCIKWU8Ra7CBWAqyyoc8OF7zv8yORY0JZg+uQBXBXfHc=
=K6/k
-----END PGP SIGNATURE-----
--=-=-=--
