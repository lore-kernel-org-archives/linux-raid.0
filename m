From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] Fix: Sometimes mdmon throws core dump during reshape
Date: Tue, 6 Sep 2011 12:09:54 -0700
Message-ID: <CABE8wwuNBOG6wcmw+TEkTNZPXGQJ63c6eLeJQz+aWQE0_S1v2g@mail.gmail.com>
References: <20110905103955.4372.52448.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110905103955.4372.52448.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, Sep 5, 2011 at 3:39 AM, Adam Kwolek <adam.kwolek@intel.com> wro=
te:
> Problem was found during reshaping 2 volumes /raid0 and raid5/ in con=
tainer.
> Sometimes mdmon throws core dump due to NULL pointer exception.
>
> Problem occurs in scenario:
> - managemon: is about spare activation (degraded raid4 volume =3D=3D =
raid0 under takeover)
> - managemon: detect level change and signals monitor (manage_member()=
 calls replace_array())
> - monitor: detects transition raid4/5->raid0 and sets a->container to=
 NULL
> =A0 =A0 =A0 =A0 =A0 to indicate array deactivation

Maybe I have lost track of the reshape implementation but I don't see
where the monitor sets ->container to NULL during a reshape?  Do you
mean deactivate mdmon for the array after the reshape completes?

> - managemon : continues his work and tries to activate spare (a->chec=
k_degraded is set).
> =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL pointer is passed to metadata handler=
 activate_spare()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0Core dump is generated.
>
> To resolve this situation managemon (after monitor kick) checks again
> a->container pointer to learn if current array is not to be deactivat=
ed.
[..]
> diff --git a/managemon.c b/managemon.c
> index d020f82..3540dac 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -475,6 +475,12 @@ static void manage_member(struct mdstat_ent *mds=
tat,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 /* we are after monitor kick,
> + =A0 =A0 =A0 =A0* so container field can be cleared - check it again
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (a->container =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +

Isn't this still racy?  Because we don't wait for the monitor to run
before proceeding.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
