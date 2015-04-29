From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3 v2] wait: introduce wait_event_exclusive_cmd
Date: Thu, 30 Apr 2015 08:17:13 +1000
Message-ID: <20150430081713.7ad33eb7@notabene.brown>
References: <1430275735-20290-1-git-send-email-yuanhan.liu@linux.intel.com>
	<20150429093109.GS5029@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/MQHqMWI5=tJhdY28rwlAlh4"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150429093109.GS5029@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
List-Id: linux-raid.ids

--Sig_/MQHqMWI5=tJhdY28rwlAlh4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Apr 2015 11:31:09 +0200 Peter Zijlstra <peterz@infradead.org>
wrote:

> On Wed, Apr 29, 2015 at 10:48:53AM +0800, Yuanhan Liu wrote:
> > It's just a variant of wait_event_cmd(), with exclusive flag being set.
> >=20
> > For cases like RAID5, which puts many processes to sleep until 1/4
> > resources are free, a wake_up wakes up all processes to run, but
> > there is one process being able to get the resource as it's protected
> > by a spin lock. That ends up introducing heavy lock contentions, and
> > hurts performance badly.
> >=20
> > Here introduce wait_event_exclusive_cmd to relieve the lock contention
> > naturally by letting wake_up just wake up one process.
> >=20
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
>=20
> Thanks!
>=20
> Assuming you want to route this through Neil's MD tree:
>=20
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thanks a lot Peter!

I've queued the three patches in my md tree for 4.2.

Thanks yliu!

NeilBrown


>=20
> > ---
> >  include/linux/wait.h | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >=20
> > diff --git a/include/linux/wait.h b/include/linux/wait.h
> > index 2db8334..db78c72 100644
> > --- a/include/linux/wait.h
> > +++ b/include/linux/wait.h
> > @@ -358,6 +358,19 @@ do {									\
> >  	__ret;								\
> >  })
> > =20
> > +#define __wait_event_exclusive_cmd(wq, condition, cmd1, cmd2)		\
> > +	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 1, 0,	\
> > +			    cmd1; schedule(); cmd2)
> > +/*
> > + * Just like wait_event_cmd(), except it sets exclusive flag
> > + */
> > +#define wait_event_exclusive_cmd(wq, condition, cmd1, cmd2)		\
> > +do {									\
> > +	if (condition)							\
> > +		break;							\
> > +	__wait_event_exclusive_cmd(wq, condition, cmd1, cmd2);		\
> > +} while (0)
> > +
> >  #define __wait_event_cmd(wq, condition, cmd1, cmd2)			\
> >  	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
> >  			    cmd1; schedule(); cmd2)
> > --=20
> > 1.9.0
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/MQHqMWI5=tJhdY28rwlAlh4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUFYaTnsnt1WYoG5AQIf0xAAp7YVFF5mG6eyi6sfK4gBbicA0mxb45MD
EJA4kXrWoQYaOClpWbtqPp0ZjsfkQd5BpmddpfSuWJxdv2Rff6r3EBNtRnbhAAMm
tgh4PTP3C0UGmcVAxTPE/ghmplmKS+pQ5ZqAqrIW5oXRrBzZTZcRNXhskvI8jLCz
V/19QoCzMXTdf9HaLsPMj8QjhSX60je/sENhZPqz1KgpOnbYFr7+zcbQm3J6KnfP
jzInI/3f7V146oG/LzBy2BaFRm5sn0whqGPE1xz7KM3Vlsrc8oW5klNx2R3lTF/m
r32vFODNsP9XovTPj4gN75YC53iguU7w22hAQz0dMLK/MHPP5km+QKDABkEvOuuu
lcFASkEdw60/d1UZiRqiXjKVuatpTk4hON5ONvXjW0RzlH4/XYYS5khcB9F1kVVO
BdYdZZAx44z/HjTDFrTxLdNw0kWOS5/J+mdr+ALHJOoevTvDPdgh4diY/bC/TzwH
FwdrqofUTVkrLKwUfUsFtnmjMe5KSwv6g4qgRkSoXnlweAg3E9nphQkwWdzKp213
dXJk4reobP2uORlAHHLtNztQ7dbaP8YVR0/TZjjo+vebUq0u6oA0B74RlsdClNc9
YTaJYAQ76LxgBg0ZnsmddYE9lPB7bp5EniGaxuuhcMHeEzzmsjt6m37wC/Mj1z75
R5NUdh2cg8g=
=e9BN
-----END PGP SIGNATURE-----

--Sig_/MQHqMWI5=tJhdY28rwlAlh4--
