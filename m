From: Neil Brown <neilb@suse.com>
Subject: Re: performance issue (was: Re: kernel: BUG: soft lockup - CPU#1 stuck for 60s!)
Date: Mon, 26 Oct 2015 06:10:47 +0900
Message-ID: <874mhefyco.fsf@notabene.neil.brown.name>
References: <1092031595.20151015153830@oudeis.org> <87si5bvcj4.fsf@notabene.neil.brown.name> <43246687.20151024181541@oudeis.org> <20151024213139.5b20dec6@natsu> <16514313.20151025202337@oudeis.org> <87a8r6g188.fsf@notabene.neil.brown.name> <1939397312.20151025213258@oudeis.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1939397312.20151025213258@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer =?utf-8?Q?F=C3=BCgenstein?= <rfu@oudeis.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rainer F=C3=BCgenstein <rfu@oudeis.org> writes:

> Hello Neil,
>
> Sunday, October 25, 2015, 9:08:39 PM, you wrote:
>
>> Depending on kernel version, it will either work or it won't.
> # mdadm --grow /dev/md0 --bitmap=3Dnone
> mdadm: failed to remove internal bitmap.
> md: couldn't update array info. -16
>
> so it doesn't work with this kernel. will upgrade ASAP.
>
>> Either way, it won't cause harm.
> famous last words ;-)
>
>> Weekly is a bit more often than I would go for, but why disable it?
> because  a  resync  runs  for a bit more than two days. but running it
> monthly seems to be a good trade-off.
>
>> That isn't a cronjob started resync. That would say "check" rather than
>> 'resync".
>> This looks a lot like a resync after an unclean restart.  But with the
>> bitmap that should go faster...
> you've   got   me  here.  resync  started at 04:22am, the same time as
> cron.weekly.  there  was  a  99-raid-something  script  in cron.weekly
> (before  I  deleted  it).   system  is  up  for some 2 days before the
> resync, so no unclean restart.

Hmmm... is your kernel older than 2.6.19?  If so, that would explain it.
Prior to 2.6.19, 'check' was reported as 'resync'.

>
>> What does "mdadm --examine-bitmap /dev/sdb1" report?
>
> # mdadm --examine-bitmap /dev/sdb1
>         Filename : /dev/sdb1
>            Magic : 6d746962
>          Version : 4
>             UUID : 8d3586a2:6adbc781:ee187e6d:500f9b34
>           Events : 4945261
>   Events Cleared : 4945261
>            State : OK
>        Chunksize : 4 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 2930265344 (2794.52 GiB 3000.59 GB)
>           Bitmap : 715397 bits (chunks), 51 dirty (0.0%)

50% dirty!  That is more than I would expect.  So even if it was a real
resync it would be going quite slowly.  I guess you'll just have to wait
it out.

Maybe you could:
  echo idle > /sys/block/md0/md/sync_action

That will abort a 'check'.  If it restarts automatically, md thinks it
was doing a real resync.  If it doesn't you should be able to remove and
re-add the bitmap.
Then maybe check with --examine-bitmap again.

But definitely update your kernel if you are on 2.6.something.

NeilBrown


>
> hth.
>
> --=20
> Best regards,
>  Rainer                            mailto:rfu@oudeis.org

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWLUVXAAoJEDnsnt1WYoG5cNIQALP0KaOlbe6jcFIQb6A+fFhF
1AhA0Y/rvqGVuoMfS4WsrQ3PTrbq4m7ChTNSkY3bZC1c9WwwWZOzUWq/MGPouagT
2V3+ub0MXJfsjogIa9CPUvOUEJI+O5galg3MGBxHE5w7hJnx4F87p2lQUV/cRY78
sJrEGUmMJqvHYmpwXsFhMK1eje5MQ6BbdT5AkglZgnvO9THS74r++BFTfVhIDfJC
xEvYrM53CcOXtjOPIj7JW+pv99z86H5GEpJQcWty4DJ5Pru/PThTzY0kMXJ+phgc
0taUDLJNo6fhv9Uzhh4o/a64raU9cpSayULS3BAE7LJoAyDhp4BDXf7V02U3KsaH
aUQy04+HCwnTnWXNoepZxl+ha1+7hSspl2All4zu9O+UPdJ1VKrcSpuqWS0lSTDj
ytB5X5ZY0nKqPxAH5kf1UeCnTVxxq26zAswxAAwUvHD/95on+P6U8QPGUu9p3sT4
t/SIbe/eLh0J4+LB4qieEVKbcccFB7lJ5g9N4oOwg1hh9JOyulniPgKcGAQzioZL
91+JPHfDqrHYJ5QVZiW816tP60Z+zwH7jqHXJnwxpI93oaLjQtGdWxx2cDP3ZvR3
4FXzj3V2ZcVBDs+fSsTrMTqsCO3tLGQtthO9kNUrhXYkdhayM9tU1fEBnrkg5zfP
YLO9MzoWDLPMEwSMwP2B
=xAsy
-----END PGP SIGNATURE-----
--=-=-=--
