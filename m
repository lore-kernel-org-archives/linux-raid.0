From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V2] md-cluster: make md-cluster also can work when compiled into kernel
Date: Mon, 05 Sep 2016 11:56:02 +1000
Message-ID: <87pooj9kjx.fsf@notabene.neil.brown.name>
References: <1472813500-4921-1-git-send-email-gqjiang@suse.com> <1472911410-15469-1-git-send-email-gqjiang@suse.com> <87zinn9rkc.fsf@notabene.neil.brown.name> <57CCCE88.4010507@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57CCCE88.4010507@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
Cc: shli@kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 05 2016, Guoqing Jiang wrote:

> On 09/04/2016 07:24 PM, NeilBrown wrote:
>> On Sun, Sep 04 2016, Guoqing Jiang wrote:
>>
>>> The md-cluster is compiled as module by default,
>>> if it is compiled by built-in way, then we can't
>>> make md-cluster works.
>>>
>>> [64782.630008] md/raid1:md127: active with 2 out of 2 mirrors
>>> [64782.630528] md-cluster module not found.
>>> [64782.630530] md127: Could not setup cluster service (-2)
>>>
>>> Fixes: edb39c9 ("Introduce md_cluster_operations to handle cluster func=
tions")
>>> Cc: stable@vger.kernel.org # v4.1+
>> The above results in you sending email to
>>     stable@vger.kernel.org#v4.1+
>> which is not a valid address.
>>
>> The correct form for comments in email address is to use parentheses.
>> e.g.
>>     Cc: stable@vger.kernel.org (v4.1+)
>
> Thanks for correct it!
>
>>> Cc: NeilBrown <neilb@suse.com>
>>> Reported-by: Marc Smith <marc.smith@mcc.edu>
>>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>>> ---
>>> Changes:
>>> 1. call try_module_get if md_cluster_ops is already set,
>>> otherwise try_module_get/module_put are unbalanced.
>>>
>>>   drivers/md/md.c | 14 +++++---------
>>>   1 file changed, 5 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 67642ba..6ac5abe 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -7610,16 +7610,12 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);
>>>=20=20=20
>>>   int md_setup_cluster(struct mddev *mddev, int nodes)
>>>   {
>>> -	int err;
>>> -
>>> -	err =3D request_module("md-cluster");
>>> -	if (err) {
>>> -		pr_err("md-cluster module not found.\n");
>>> -		return -ENOENT;
>>> -	}
>>> -
>>> +	if (!md_cluster_ops)
>>> +		request_module("md-cluster");
>>>   	spin_lock(&pers_lock);
>>> -	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
>>> +	/* ensure module won't be unloaded */
>>> +	if (!try_module_get(md_cluster_mod)) {
>> Why did you drop the "!md_cluster_ops" test?
>>
>> What happens if the md-cluster module cannot be loaded?
>> md_cluster_ops will be NULL and md_cluster_mod will be NULL.
>> try_module_get(NULL) succeeds, so with this patch md_setup_cluster()
>> will succeed if the module is needed but fails to load.
>
> Yes, I just find try_module_get(NULL) could return true, it seems not
> correct for the return value, maybe it need to be changed to:
>
>              return module ? ret : false;

If a module is built into the kernel, then the module pointer that code
will use with be NULL, but you still want try_module_get() and
module_put() to work.  So I think returning 'true' for NULL is correct.

>
> Anyway, I will send v3 with add "!md_cluster_ops" test back.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJXzNCyAAoJEDnsnt1WYoG5PFEP/1ZvDUl5WFnj3Kh4sXHbMOFu
y83hKZz1pOp+vbFCeofTjUotXeO9zDecLR0tVv/JMLBDFBhtBBXRCVxExN1gnlni
SzzudEYTvqsws8zapNwGpptI3qWw8Q5hqmK01sKJrEWazrKtslHL4joDQB/MaSS2
7XLvXOGEjvCemfo0StOtOJP5I27U85mm2AAVR2mMeVo68bBhrH8V5GP2u2jTL2gO
F1fnW1YmqB4qFGsk1DL9wzIgEGccEbUnk9qAFG5xGeXnRkCc2452Fohr0eYDlpVm
Hb3Qd8ZBTSRGXBFcnOQG+LvtKdJly1FjDq9uOLgnbj7rXWK2pvYou4Z6qCRelrL9
S0InQtp1yeLDQoaZCzspf2lSBgHpNCWCAABPM0zj+zj7nc/Tn43poqVHoqdtemaw
gI7mJsN3q3k3FCKmGQlIE9wp06D/pfRFxX+FPh+aPclInz1UETev1AZPfL3nU0w0
XA6rAkgUnjSzvFjOiJ7tl+mNfPD64ujQl50W6V8mq0qzHfrjSxH5PdIJUVh65A/b
7FSHB7bnAude7EERTyDsiI2jc9AIi+7QM3BDpNQN44XfnxTY7401dPnDFrdoDW7a
xKUBiL4tFw0ZG3+5KIlYGVAbFAgd9CLmE1wpUuBcRPdReJDbsdVmiAL7DBpdmELH
Nc+8LqxrLo6JQEV5DGP3
=pT0m
-----END PGP SIGNATURE-----
--=-=-=--
