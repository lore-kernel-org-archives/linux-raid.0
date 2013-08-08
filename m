From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 9/9] Create: set array status to frozen until monitoring
 starts
Date: Thu, 8 Aug 2013 10:44:45 +1000
Message-ID: <20130808104445.7158f437@notabene.brown>
References: <52016A06.8070400@arcor.de>
	<1375825083-7856-5-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kWr1LykeTUoeUBshzY1hm1V"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375825083-7856-5-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kWr1LykeTUoeUBshzY1hm1V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  6 Aug 2013 23:38:03 +0200 mwilck@arcor.de wrote:

> When we create an array while mdmon is working on an event
> (e.g. disk failure), the meta data on disk may not be up-to-date.
>=20
> Patch "DDF: ddf_open_new: check device status for new subarray"
> added some checks for in the monitor for that situation - in particular,
> to handle a freshly created array with faulty disks. The remaining
> problem is that the kernel may start syncing the disks before this
> situation is detected. This patch delays recovery until mdmon finished
> checking.
>=20
> tests/10ddf-fail-create-race should succeed reliably with this patch
> and "DDF: ddf_open_new: check device status for new subarray". Without,
> it will fail sporadically.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  Create.c    |    8 ++++++++
>  managemon.c |    6 ++++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index ac22f77..f9b7db2 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -993,6 +993,14 @@ int Create(struct supertype *st, char *mddev,
>  				need_mdmon =3D 0;
>  				break;
>  			default:
> +				/*
> +				 * The meta data we saw on disk may not be
> +				 * up-to-date. The monitor will check and
> +				 * possibly fail. Avoid a resync happening
> +				 * in the kernel before that.
> +				 */
> +				sysfs_set_str(&info, NULL, "sync_action",
> +					      "frozen");
>  				err =3D sysfs_set_str(&info, NULL, "array_state",
>  						    "readonly");
>  				break;
> diff --git a/managemon.c b/managemon.c
> index f40bbdb..5bc54da 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -744,6 +744,12 @@ static void manage_new(struct mdstat_ent *mdstat,
>  		new->container =3D NULL;
>  		free_aa(new);
>  	} else {
> +		/*
> +		 * Create() set this to frozen.
> +		 * This relies on the kernel clear FROZEN status
> +		 * if an invalid value is written to sync_action.
> +		 */
> +		sysfs_set_str(&new->info, NULL, "sync_action", "");
>  		replace_array(container, victim, new);
>  		if (failed) {
>  			new->check_degraded =3D 1;


I don't think that this patch should be necessary.
If you find it makes a difference, then I'm missing something.

Recovery never starts while the array is readonly - the kernel doesn't allow
it.
So mdmon should be in complete control as it is the only one that is allowed
to change the array from readonly.

Whether it quite does the right thing in this case I can't promise, but it
should be able to do the right thing without any extra help from mdadm.

And writing an empty string to 'sync_action' will not do anything useful.
You probably mean to write "idle".

I've applied and push out the previous patches but not this one.

Thanks,
NeilBrown


--Sig_/kWr1LykeTUoeUBshzY1hm1V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgLp/jnsnt1WYoG5AQKG2A//Tj+HrxHqzmCj2RNoBFnoCOSd1+oDqS4O
IXhZqvblsn9V1HeRgDJBrbjzjwg5ZQdp8q0uUzFMP0F4RiakP5L1ipzf6pJ3AA5V
U6IcgI0SlnjOUJqtSiL8m1jKFNCypmJq3jcS/YnLmX+3fzJ+NXHSsA+St2XO6JH+
yGYH8SU8l3ln1l3MLAQZqkTSORzmzfBiWhy9Cq8ecCCbU5tV8sJGa3Kt1e3rUPD+
fM0PR+Rhv0fC13jpUp/K07mVvv9OeAq6RekDixjExNCvqSDdyLB0ez7W2D2PyqEb
Yb3NI/OOBDu3fBxfxN+M3LFQ3YLWa5W8w28zwMNYDKdCBmvXfQBRxq3tTiYneRxT
BdUAuEvxZkXitvf7U1yJIz24GHjWq8WsW9xpFVADGjYfHM/8O7P+08HQ3QH4wMOl
2yG9HpkurGIViL8J8xFnpBgvlGje/gI9UBZ04Z+fk6kZZIpI5E8yLuXLqu3/lus+
7Myd2q/h5wUGM7msc3Ukptg4xeBzqY7ijLd9IkW5u5Luk/YmiMkp1LkgksWAQI0w
65ZZrbWZjAGI6KSlGknSicWDZGdc0SV9PECj5m5ADGATd6q1Kp4y+NGfgW4OMXxB
r77fIaH9q7L1rq2BhBIIZMFo8I/CT1yjyB82v9Jgzdaxah9D4tVmzZuWcsnDHH3w
imd977RKfZQ=
=CHPM
-----END PGP SIGNATURE-----

--Sig_/kWr1LykeTUoeUBshzY1hm1V--
