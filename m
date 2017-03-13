From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/4] mdadm:checking level once mode has been set
Date: Mon, 13 Mar 2017 14:48:35 +1100
Message-ID: <8737ehg7l8.fsf@notabene.neil.brown.name>
References: <20170308074831.24683-1-zlliu@suse.com> <878toaf6me.fsf@notabene.neil.brown.name> <65454fe3-6165-5d02-eecd-02f8aac8f422@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <65454fe3-6165-5d02-eecd-02f8aac8f422@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: zhilong <zlliu@suse.com>, Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Mar 13 2017, zhilong wrote:

> On 03/13/2017 06:54 AM, NeilBrown wrote:
>> On Wed, Mar 08 2017, Zhilong Liu wrote:
>>
>>> mdadm: it would be better to check --level ealier,
>>> because it would fall to different prompt if user
>>> forgets to specify the --level. such as:
>>> ./mdadm -CR /dev/md0 -b internal -n2 -x1 /dev/loop[0-2]
>> When I run that command I get:
>>
>>    mdadm: a RAID level is needed to create an array.
>>
>>
>> What do you get?
>
> I'm sorry I have provided the wrong command, for this scenario,
> issues "mdadm --build /dev/md0 -n2 /dev/loop[0-1]" should be
> proper. it's the purpose to check --level earlier.

OK, that makes sense.

>
> If this patch is useful, I would send the v1 patch for it, correct the
> comments.

My preference would be to have the check in Build.c, but Jes might have
different ideas.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljGFpMACgkQOeye3VZi
gbnJzQ/9ENgusylN/OynBbcwbWR2OfLJvgh33LPzawdQFcUda++O3cg6a50Lg/yh
7KRY0ztzBt7pSlxZtDWzvi8oo21NrJRbhJsD+ApNlnlsf/E82X/zLeAlkrhku/nH
hkgX7duU6YPx2jkT1PBKX5EELbvNRD8IQvg2jcrP0rpsi/G7FV+lP0iCCvUgHGES
J+L3ohngHLSOKVF6gAwSILqcQ+wjNliFo35ODCXMX/b3ejSysPeTBTGjEuurpWgm
36/bdvChgKMZm1BMGL7j2/pTrX6Pv09wJUVdzn3d26k96dvLqPXGYZl6dlQQTNEI
HFPc7W5noitEmmW5dH9yxDcWReUmvv1AVmH11Bcgt0Fxm/XyAHJrmvPqn5xTHtRE
xt2VBsMQ5nWnZ6toI5y6Fd4PtVMNZas7fBQuXeELQdOD3fXbS6DGmdQ7LuZkFn//
+NahGelZoEXiuBWcx9HUtjC0MSxOIeBFFdeogY9prqtx4wTegiYv0Wl57B3OmdWz
+Zhzgo5Ie5lAIhM8QIoMpi4Tb9Eax8JPSZblQLjIBMMnl9lrYpfMsEZeXYP63dMH
uzPOP4GfmymjNCSBlzgEtxQjkc8aXBJopsOJHgIh4hQswFo9a9guYWJTtHQBA7U7
d/u/ZiKD1UkZW7r2t6idsMuR1IYIIqEbi/j1kp7XC9vmaqgoMvY=
=28rr
-----END PGP SIGNATURE-----
--=-=-=--
