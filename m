From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v1] md: Convert to use int_pow()
Date: Fri, 26 Jul 2019 17:18:09 +0000
Message-ID: <F7CF9393-B366-4810-B127-876C6D5A72A1@fb.com>
References: <20190723204155.71531-1-andriy.shevchenko@linux.intel.com>
 <20190726164823.GB9224@smile.fi.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190726164823.GB9224@smile.fi.intel.com>
Content-Language: en-US
Content-ID: <EAD09523AB061648A24EB869500B7D81@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Coly Li <colyli@suse.de>, Mikulas Patocka <mpatocka@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids



> On Jul 26, 2019, at 9:48 AM, Andy Shevchenko <andriy.shevchenko@linux.int=
el.com> wrote:
>=20
> On Tue, Jul 23, 2019 at 11:41:55PM +0300, Andy Shevchenko wrote:
>> Instead of linear approach to calculate power of 10, use generic int_pow=
()
>> which does it better.
>=20
> I took into Cc drivers/dm guys as they might have known something about m=
d raid
> state of affairs. Sorry if I mistakenly added somebody.
>=20
> Who is doing this?
> Should it be orphaned?
>=20
> (I got a bounce from Shaohua address)

I process the patch. Sorry for the delay.

Song

>=20
>>=20
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> ---
>> drivers/md/md.c | 6 +-----
>> 1 file changed, 1 insertion(+), 5 deletions(-)
>>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 24638ccedce4..3f1252440ad0 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -3664,11 +3664,7 @@ int strict_strtoul_scaled(const char *cp, unsigne=
d long *res, int scale)
>> 		return -EINVAL;
>> 	if (decimals < 0)
>> 		decimals =3D 0;
>> -	while (decimals < scale) {
>> -		result *=3D 10;
>> -		decimals ++;
>> -	}
>> -	*res =3D result;
>> +	*res =3D result * int_pow(10, scale - decimals);
>> 	return 0;
>> }
>>=20
>> --=20
>> 2.20.1
>>=20
>=20
> --=20
> With Best Regards,
> Andy Shevchenko
>=20
>=20
