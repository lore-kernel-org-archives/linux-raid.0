From: NeilBrown <nfbrown@novell.com>
Subject: Re: md-cluster Module Requirement
Date: Thu, 01 Sep 2016 15:52:15 +1000
Message-ID: <87h9a0cgkw.fsf@notabene.neil.brown.name>
References: <CAHkw+Lf82YEZ3qm9KJ_b_2pUiNFh=nDeEBXYV5PdgtEUtij8eg@mail.gmail.com> <57C79011.9090404@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57C79011.9090404@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Marc Smith <marc.smith@mcc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 01 2016, Guoqing Jiang wrote:

> On 08/26/2016 10:40 AM, Marc Smith wrote:
>> Hi,
>>
>> I'm attempting to use md-cluster from Linux 4.5.2 with mdadm 3.4 and
>> I'm running into this when attempting to create a RAID1 device with
>> the clustered bitmap:
>>
>> --snip--
>> [64782.619968] md: bind<dm-4>
>> [64782.629336] md: bind<dm-3>
>> [64782.630008] md/raid1:md127: active with 2 out of 2 mirrors
>> [64782.630528] md-cluster module not found.
>> [64782.630530] md127: Could not setup cluster service (-2)
>> [64782.630531] md127: bitmap file superblock:
>> [64782.630532]          magic: 6d746962
>> [64782.630533]        version: 5
>> [64782.630534]           uuid: 10fee18f.f553d7f2.deb926f1.c7c4bd4b
>> [64782.630534]         events: 0
>> [64782.630535] events cleared: 0
>> [64782.630536]          state: 00000000
>> [64782.630537]      chunksize: 67108864 B
>> [64782.630537]   daemon sleep: 5s
>> [64782.630538]      sync size: 878956288 KB
>> [64782.630539] max write behind: 0
>> [64782.630541] md127: failed to create bitmap (-2)
>> [64782.630577] md: md127 stopped.
>> [64782.630581] md: unbind<dm-3>
>> [64782.635133] md: export_rdev(dm-3)
>> [64782.635145] md: unbind<dm-4>
>> [64782.643111] md: export_rdev(dm-4)
>> --snip--
>>
>> I'm using md-cluster built-in, not as a module:
>> # zcat /proc/config.gz | grep MD_CLUSTER
>> CONFIG_MD_CLUSTER=3Dy
>>
>> It seems the driver is attempting to load the 'md-cluster' module
>> (from drivers/md/md.c):
>> --snip--
>>          err =3D request_module("md-cluster");
>>          if (err) {
>>                  pr_err("md-cluster module not found.\n");
>>                  return -ENOENT;
>>          }
>> --snip--

I think this code is wrong.  It should be more like:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d646f6e444f0..09036add7f33 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7612,15 +7612,13 @@ int md_setup_cluster(struct mddev *mddev, int nodes)
 {
 	int err;
=20
=2D	err =3D request_module("md-cluster");
=2D	if (err) {
=2D		pr_err("md-cluster module not found.\n");
=2D		return -ENOENT;
=2D	}
+	if (!md_cluster_ops)
+		request_module("md-cluster");
=20
 	spin_lock(&pers_lock);
 	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
 		spin_unlock(&pers_lock);
+		pr_err("md-cluster module not found.\n");
 		return -ENOENT;
 	}
 	spin_unlock(&pers_lock);

>>
>> I looked at linux-next and it appears this code is the same; is there
>> a test we can do before attempting to load the module in the case that
>> its built-in, or is there some other requirement that md-cluster needs
>> to be built as a module?
>
> Yes, we need some additional modules corosync/pacemaker and dlm,

That doesn't explain the error message though.
If MD_CLUSTER is built in, then DLM must be too.

NeilBrown


> pls refer to http://www.spinics.net/lists/raid/msg47863.html, HTH.
>
> Regards,
> Guoqing
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJXx8IPAAoJEDnsnt1WYoG5gDQQAIiRE8c4ivPZe4s2nylZlnk2
F/W3L9TOiED9UBTSXzXhUcZ6Y7bI9wXISYtgsp+H5azqGezVFCYUPM5vGvpoMOP+
8T9offisqYBlIXcwz/wy+1eD4V3Sz6B2L4cnqOCX4pmOZJJZHqP2+PTFnm/30KA4
hRot+b33IY9dj4SS0nh/m0bhGs7qAV6n/eDJQemKU0jrJAptgKnUa9UocmIjkSHz
mCpv0fg2Z+5FKzBxFlHFIV0Rkz2lJR8rf0aN/iEtF1sruFkbM8hLtqMuIBIJH4ot
CBqOXT/GHAi/xgDbNJh6Tzd3Po+hkhBjz2IGX698DVcw23UhtTmP5tT/AETvFuFM
FJmXjXuONL16hTTZeDBl0LO3p0dK4ftOuH8f3X7a0mBo1kmfQQO35MV3RV+LsM9w
PDpqZwTSwkrTKeOhYqpORLhvvcmjAguHo+voqqBautwqaffPXIpbKco/pd3P31sf
LzdmDVuFCr2xKNa9I1XOuJXr2qOzkUtrOaS9T0A1Z6iLyhiSEK4GBLCsBrSLC75W
s0IpzcTiy9x9JeE9au/nr/TIQG8gxJLIRm/diaiBJ7+83OJUcOrfinXGanlLMjnK
+bGeFVRESao4JP/rkN5ugWeOjcUGE7V6QrBz6D1sAOBPWpZAlJZrcFtpF4be98Un
01de1BTbaEmarm43epwQ
=b9fI
-----END PGP SIGNATURE-----
--=-=-=--
