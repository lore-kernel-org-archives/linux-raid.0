From: NeilBrown <neilb@suse.com>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname change?
Date: Tue, 22 Nov 2016 09:56:28 +1100
Message-ID: <87shqkcuhv.fsf@notabene.neil.brown.name>
References: <20161117035230.GG21587@bitfolk.com> <87lgwihc2v.fsf@notabene.neil.brown.name> <20161117150954.GH21587@bitfolk.com> <87d1hthgm7.fsf@notabene.neil.brown.name> <20161118023144.GC1804@bitfolk.com> <87poltfq2d.fsf@notabene.neil.brown.name> <20161118034716.GI21587@bitfolk.com> <87k2c1fn0o.fsf@notabene.neil.brown.name> <20161118041759.GE1804@bitfolk.com> <877f7xe9lh.fsf@notabene.neil.brown.name> <20161121060256.GL1804@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161121060256.GL1804@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Nov 21 2016, Andy Smith wrote:

> Hi Neil,
>
> On Mon, Nov 21, 2016 at 03:32:42PM +1100, NeilBrown wrote:
>> If you still want to get to the bottom of this, you might need to revert
>> your work-around, the try the "udevadm monitor" and "udevadm info" and "udevadm
>> trigger" while the array is not assembled.
>
> I have reverted my addition of "mpt3sas" from
> /etc/initramfs-tools/modules and rebooted, so that md5 is again not
> assembled.

Thanks.  Sorry this is taking a lot of back-and-forth...
Still getting
> E: ID_FS_TYPE=linux_raid_member
which is good.  Not getting and MD_*, which is bad.

I would:
 - check that md5 definitely isn't running (mdadm -S /dev/md5)
 - run mdadm -I just like udev does.

   /sbin/mdadm --incremental --export /dev/sdc --offroot /dev/disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633 /dev/disk/by-id/wwn-0x5002538c0007e7a8 /dev/disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0

(the string of paths is from the "DEVLINKS" field).

That *should* produce several lines like "MD_NAME=tbd:5" etc.
My guess is that it is producing an error.  Knowing that error message
would help.

If it doesn't produce an error, but does produce some MD_* lines, then
the problem must be that udev isn't doing quite the same thing.
So stop md5 again (mdadm -S /dev/md5), enable udev debugging
  udevadm control -l debug

and re-issue the 'change'
     echo change > /sys/block/sdc/uevent

That should puts lots of stuff in the journal.  If you could extract
that and post it I might be able to find something of interest.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYM3udAAoJEDnsnt1WYoG5ZnwQAL91bKUyNrxiG3rcnZwUoXF3
ParXEGnpuS1M1CydrzKZMKFhCmmU9zmtg549dhCblxAW/4guuWF8dYeUb9PWHHza
JIAWZAEa3cotRpezde2ClyGhhZVfkAO5Fc8OY/Der2BApbvESxMRbWWhrTkQJ6m1
9GZ6nY6f32ZU/+JlCJHnl02LqnduTZeE5yH0wihpFEU1FTEtfQrWiT2Ya3NDtE6Q
XqzoESvy7kPwqQsz8GJ5pvA7SbtehfHR8ojjYqw6J0SFawfqvqNVSdNheukXBvNy
gl3bJ7WsmrQiXAAq85pTeNfqA0+5up4WYNwP2BHeM4tILsUUlQjJETMpDkbY/1hl
i7vTbjkphXP93y6nnn6eI1dyz1l66qzQwv2F5pLeUxpXvu5jromLGAFoLWxKvQZU
e/vj4gJCWlSDjMYOKdOm8dJ4ukJNRHx7waiPNGmydZ7IPYU/wo/IW5jn/Awny20Y
yFpxucVLhPH3WcFcT+jDDS6WR2+j9PNeJ3sxMJbWR/XrFbLMXoi9KziiUVQZ3Scx
Xu+oRS26P3bA8749w9QCvHc8OMf7kRFER3U1JCsuPa105qkPljOf79XTsBXhAjN4
uqkrEm65WggJMV4v4psgCQXGXUUMgu5xdtbj1zPtM9CGF9xartzCldxqpD/fw3k9
dxb192eRheTOitq523GZ
=dcKh
-----END PGP SIGNATURE-----
--=-=-=--
