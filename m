From: NeilBrown <neilb@suse.com>
Subject: Re: stripe_cache_size, some info
Date: Fri, 24 Mar 2017 16:47:47 +1100
Message-ID: <87wpbf8buk.fsf@notabene.neil.brown.name>
References: <CAJH6TXhL4=MLanyvQh8UMkBmfkfjPd-frsCOC3PqLnDXCpMetw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXhL4=MLanyvQh8UMkBmfkfjPd-frsCOC3PqLnDXCpMetw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sun, Mar 19 2017, Gandalf Corvotempesta wrote:

> Hi to all,
> I need some info about stripe_cache_size
>
> Is that a sort of "writeback" cache? Higher the number, higher the
> amount of data to be cached in ram before writing to disks, right?

No.
All of memory is potentially a write-back cache for all filesystems.
the stripe_cache is a write-through cache which holds strips (one page
per device) while reading missing blocks and computing parity.

When the array is degraded, it is also used to hold the blocks in a
strip will calculating the missing data.

>
> Some questions:
>
> 1) any upper limit for that value ? Can I set it near 1GB like most
> hardware controller?

It is currently limited to 32768, for no particularly good reason.
Several stripes (so several times 64 with the default chunk size) is
good.  Many stripes might help very random workloads.


> 2) why on my RAID-6 I don't have /sys/block/md0/md/stripe_cache_size ?

No idea.  I certainly should do.


>
> As I would like to replace most of our HW raid controller with mdadm,
> any suggestion on how to improve RAID-6 speed ?
>
> Modern CPU aren't an issue, I don't think that double-parity
> calculation could create any bottleneck on a modern CPU.
> The real advantages of a raid controller are mostly 2:
>
> 1) the writeback cache (1GB or 2GB)
> 2) the ability to automatically replace a disk by hotswapping it.
>
> Any solution to this ? For the "2", i've tried by configuring the
> POLICY in mdadm.conf but new disk is never reconized and I always have
> to manually add the new disk to the array.

What, precisely, have you tried?  Please provide exact contents of
config files (i.e mdadm.conf) and exact steps you took and what you
expected to happen.

NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljUswMACgkQOeye3VZi
gbmW4Q//bFTkPmzO5Ga/eD72IxBqGBtEOMXpvfmq9TaFhAgSo4yhC6TiCAdvuyCj
aAhys9VDTRKPi+j/N9GiNXdz/8yel4Gt/c3++pYYDpqKnwmJAQ1725m5e5CBTt8L
bQ0bZ/T7naFXmGhYtHrO/3l2nUh3BPYqxOWpNL7whrp3L6PpVCmOwXF1ZH8W7n07
6/WxcDEsjpFHB8vUO4osCoV3CmrTFtDpp2QNvG/9tPLUQ0NlmO+1Db1/bNh7XQpS
Suow7c6YEjht1PAkqJGNtr1mdNVYbG/Qe/z8naRpLw5I3F9HwZV0930x4/fneFNH
w/JJs7O2XRBuZ0xMs1X+srPlAnkbBEbQPZCTdzZw5E5nt3ptWw7sWD/SbLOUMl/3
u6VlUqGoanEmb3AP8p2tDWGEMiUSTK/EcRSaLnHK7r6r2IoJtH32Xbj6MLiXSRbm
jrfQ5G/E8d6F1OlkunELH5o9QzjBLfkIhDK4DGrIqB5T6pojhZetyuFPvE2yGzop
K426h9CRsCygqlhs8HYnILpSrERSAra/+t4VKOZpentKMaWFsAzAEkqjS85jwRUi
Y1jcd41gB4971CpMiM7iSxe2LFw3ggWZHcmzNZCBTNf0wEv9nzCQyUOrUUXy8YWj
JR5ksfTRzbgAEQaLLLupXh9/xlDuDlnK1tKy7wkbVHOmrKLmIa4=
=bQ/U
-----END PGP SIGNATURE-----
--=-=-=--
