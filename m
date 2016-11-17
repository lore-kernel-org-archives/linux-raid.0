From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v6 06/11] md/r5cache: sysfs entry r5c_journal_mode
Date: Thu, 17 Nov 2016 11:29:10 +1100
Message-ID: <87y40j7xux.fsf@notabene.neil.brown.name>
References: <20161110204623.3484694-1-songliubraving@fb.com> <20161110204623.3484694-7-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161110204623.3484694-7-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Nov 11 2016, Song Liu wrote:

> +static ssize_t r5c_journal_mode_store(struct mddev *mddev,
> +				      const char *page, size_t len)
> +{
> +	struct r5conf *conf = mddev->private;
> +	struct r5l_log *log = conf->log;
> +	int val = -1, i;
> +
> +	if (!log)
> +		return -ENODEV;
> +
> +	for (i = 0; i < sizeof(r5c_journal_mode_str) / sizeof(r5c_journal_mode_str[0]); i++)
> +		if (strlen(r5c_journal_mode_str[i]) == len - 1 &&
> +		    strncmp(page, r5c_journal_mode_str[i], len - 1) == 0) {
> +			val = i;
> +			break;

I don't really like this "len - 1".
It is presumably there to skip a trailing newline, but it doesn't check
that there is a new line to skip.
Some people seem to have a habit of using "echo -n ...." to write to
sysfs.
I suggest.

 if (len && page[len-1] == '\n')
       len -= 1;

then just use "len" instead of "len - 1".


Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLPnWAAoJEDnsnt1WYoG5s/gP/3E+h4DUmoNgmj2fozq/WWce
fatukG+kSE7uUP5Vo3MoixuLoCbKNe3LgEWXDjhLbiBWrylL1q5ncwVifE0MYFq+
x+6nA7wm3KjcmgwU/pOJgkMkPa8sffFseIb8oy3/hOEpKN966BeEcOdu0VO1ZrFu
sISthTcrqtjejCT8MyK4fQGdGvsdtnZjyjgtgwA2KLLo5rlbzF0TFSIm0E1cJkap
06Psebgl+AQ7AjhtidMhAsyC1uMsu9558vHIstBDVOObl0D/KZOww8w/iO0AfjLe
eExC3v3U/XoCh52vhiPvM1pfnDqs209+yhhpbGxGFnl6A3mJLGyHIre6oiY9AKTf
kS5wwY+OG2gUvuwroS41xUrvsqEKT4W4tE0mvC5i/Fqh2x8N5xAtGr1fNHlyPAZJ
I0WZ1BAjEnsmdOE43oi8LKVaQOcIujMOCUau2JnUhgfHZybO+8dLMjuJqbiVstdQ
/OuFrzLP2HTCBqy91fds6kT4/gIcunwI7iCM/9BAtt55wMoBirHhV59G2Wo/VTOr
YtQ/oJIuPQXDKZg783FTocAuv1Qoxb1e4cu4qlpOEAktvZmpa7xAdocUjlkd/hjf
53+eUW8y5xqjIbkkhAe+ncVeolrbFXmxyyKiBerV0UcHtU6ua7hoMCzeetOTq+xw
MZW9aiaIU3eKgvERRV1Z
=o+Yv
-----END PGP SIGNATURE-----
--=-=-=--
