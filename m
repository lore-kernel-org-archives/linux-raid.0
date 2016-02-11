From: NeilBrown <nfbrown@novell.com>
Subject: Re: [PATCH 2/2] enable bypass raid5 journal for full stripe writes
Date: Thu, 11 Feb 2016 15:07:32 +1100
Message-ID: <87bn7nx52z.fsf@notabene.neil.brown.name>
References: <1455151995-240805-1-git-send-email-songliubraving@fb.com> <1455151995-240805-2-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1455151995-240805-2-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 11 2016, Song Liu wrote:

> Summary:
>
> Resending the patch to see whether we can get another chance...
>
> When testing current SATA SSDs as the journal device, we have
> seen 2 challenges: throughput of long sequential writes, and
> SSD life time.
>
> To ease the burn on the SSD, we tested bypassing journal for
> full stripe writes. We understand that bypassing journal will
> re-introduce write hole to the md layer. However, with
> well-designed application and file system, such write holes
> should not result in any data loss.

"should not" isn't very encouraging.
I've always thought that the "write hole" was more of a theoretical than
a practical concern.  But if we go to the trouble of preventing them, I
really think we need "will not".

I don't suppose we could ask the filesystem to tag certain requests with
a flag which say "If the system crashes before this write completes, I
promise to re-write the entire region (possibly with different data)
before trusting any data I read from here".
That is what you really need.
But it wouldn't help for in-place overwrites.

>
> Our test systems have 2 RAID-6 array per server and 15 HDDs
> per array. These 2 arrays shared 1 SSD as the journal (2
> partitions). Btrfs is created on both array.
>
> For squential write benchmarks, we observe significant
> performance gain (250MB/s per volume vs. 150M/s) from
> bypassing journal for full stripes.

You need a faster SSD :-)

>
> We all performed power cycle tests on these systems while
> running a write workload. For more than 50 power cycles,
> we have seen zero data loss.

That doesn't fill me with any confidence.
To get even close to a credible test, you would need to instrument the
kernel so that at some (random) point it would never send another IO
request until a reboot, and so that this random point was always
somewhere in the middle of submitting a set of writes to a stripe.

Instrument a kernel to do this, demonstrate that the write-hole causes
problems, then demonstrate that it doesn't with the various patches
applied.  Then do this across a range of tests (write-in-place, append,
etc) on a range of filesystems.
Testing for data integrity is *hard*.

And as you say, it may be up to the application to ensure it doesn't use
corrupt data (like a partial write).  Testing that is not really
possible.
If you were to make it possible to do this, you would need to be very
explicit about what sort of write-hole corruption could still occur, so
that users could make an informed decision.

(I assume your test had a degraded array... you didn't explicitly say
so, but the test would be meaningless on a non-degraded array so you
probably did).

>=20=20
> +static ssize_t
> +r5l_show_bypass_full_stripe(struct mddev *mddev, char *page)
> +{
> +	struct r5conf *conf;
> +	int ret =3D 0;
> +
> +	spin_lock(&mddev->lock);
> +	conf =3D mddev->private;
> +	if (conf) {
> +		if (conf->log)
> +			ret =3D sprintf(page, "%d\n",
> +				      conf->log->bypass_full_stripe);
> +		else
> +			ret =3D sprintf(page, "n/a\n");
> +	}

Given that this is a boolean, I would much prefer it was consistently a
boolean value, never "n/a".
Not sure if 0/1 Y/N T/F is best, but one of those.

Otherwise the code looks sensible (assuming the idea is sensible, which
I'm not 100% convinced of).

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWvAkEAAoJEDnsnt1WYoG5eeIP/i6K3BhqS8uVyTmRjoGBITDX
t4cYRnzqJGsT92ZzuVQcMHUqGXiw2DZHwzWWTT+ml6W47Ktj3QyTjU5+ZCb8LXKi
yMFyO/TahUhhsuax41vTQMhhNSHb7tH/yxCrQNbSG95qeeWhT/u3iiGbfRMdWfho
jRnvPFDvW3wFuS/FlQVpZTIhI7nQoC9OTxbbY3+jFuZazp2yhi33QtnrmvoYw1GZ
gtGhv9IatN6h/szQIiy+jkinfCS5yDY6fKQYtM3jF23VbzAaU5pVtm6EIAOaWafH
W8h4SndhNIxGtpMtDqMqQIXylwe32LniwR6NppfHRZrc/GA5AofzdgixuCz761yI
GrXteoUSV7T4mUmvi7uppv6aF0PSYTXbrcHhdwYqMzKu1a1oFeTw7UmBVfAys7V8
ueV/X1MQ+K/7GW1X9AwQBmcIZvEubUl+PSi+SJy+ldLEg7swKnWvu66TehFybwho
dV6eHCzQVTFBtE64E+Z2Cl/Wrjj0oKYWQz1lSEmQ/RYiPTJ5R9IRbBx+vTm84Bun
DWQ4FeXuNKTnFPkR8bWgn5+ECcxjORJBbuV2lRD8wrF+IOQ3a7jLx2V8ma8N02Up
iMxwUiEeyuYtQBv0P8WYo61G89dcPcnJSXbh8vCkXK8O/2Aoj0cwPDY7TQn9rCyn
rvC91I1bsKWavV9dhCvd
=Zb2g
-----END PGP SIGNATURE-----
--=-=-=--
