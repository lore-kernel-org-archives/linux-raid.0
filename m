From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v3] mdadm/r5cache: allow adding journal to array without
 journal
Date: Tue, 28 Mar 2017 18:05:33 +0000
Message-ID: <EAA4AED1-DAB6-455F-B416-E9F67CA635F1@fb.com>
References: <20170317233111.2452831-1-songliubraving@fb.com>
 <20170317233111.2452831-2-songliubraving@fb.com> <wrfjpoh1gufa.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjpoh1gufa.fsf@gmail.com>
Content-Language: en-US
Content-ID: <5AD569395CF21B4FB59EE76D3AFFF033@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, Dan Williams <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>
List-Id: linux-raid.ids

On Mar 28, 2017, at 10:52 AM, jes.sorensen@gmail.com wrote:
>=20
> Song Liu <songliubraving@fb.com> writes:
>> Currently, --add-journal can be only used to recreate broken journal
>> for arrays with journal since  creation. As the kernel code getting
>> more mature, this constraint is no longer necessary.
>>=20
>> This patch allows --add-journal to add journal to array without
>> journal.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> Manage.c   | 9 ---------
>> mdadm.8.in | 5 ++---
>> 2 files changed, 2 insertions(+), 12 deletions(-)
>>=20
>> diff --git a/Manage.c b/Manage.c
>> index 5c3d2b9..d038b68 100644
>> --- a/Manage.c
>> +++ b/Manage.c
>> @@ -946,7 +946,6 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv=
,
>>=20
>> 	/* only add journal to array that supports journaling */
>> 	if (dv->disposition =3D=3D 'j') {
>> -		struct mdinfo mdi;
>> 		struct mdinfo *mdp;
>>=20
>> 		mdp =3D sysfs_read(fd, NULL, GET_ARRAY_STATE);
>> @@ -960,14 +959,6 @@ int Manage_add(int fd, int tfd, struct mddev_dev *d=
v,
>> 			pr_err("%s is not readonly, cannot add journal.\n", devname);
>> 			return -1;
>> 		}
>> -
>> -		sysfs_free(mdp);
>> -
>=20
> Song,
>=20
> Sorry for nagging you again on this one, however removing
> sysfs_free(mdp) means you are leaking mbp here.
>=20
> Cheers,
> Jes

Oops... new patch coming...

Thanks,
Song
