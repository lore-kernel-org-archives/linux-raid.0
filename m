From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: Possible bug in DM-RAID.
Date: Wed, 21 Oct 2015 09:19:59 -0400
Message-ID: <562790FF.1060401@gmail.com>
References: <562659DD.1000505@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040903000009000007070608"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562659DD.1000505@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.org
List-Id: linux-raid.ids

This is a cryptographically signed message in MIME format.

--------------ms040903000009000007070608
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-20 11:12, Austin S Hemmelgarn wrote:
> I think I've stumbled upon a bug in DM-RAID.  The primary symptom is th=
at when
> creating a new DM-RAID based device (using either LVM or dmsetup) in a =
RAID1
> configuration, it very quickly claims one by one that all of the disks =
failed
> except the first, and goes degraded.  When this happens on a given syst=
em, the
> disks always 'fail' in the reverse of the order of the mirror numbers. =
 All of
> the other RAID profiles work just fine.  Curiously, it also only seems =
to
> happen for 'big' devices (I haven't been able to determine exactly what=
 the
> minimum size is, but I see it 100% of the time with 32G devices, never =
with 16G
> ones, and only intermittently with 24G).
OK, I've done some more experimentation, and have figured out that=20
adjusting the sync region size from the default (and thus adjusting the=20
bitmap size) can temporarily work around this.  If I adjust things so=20
that the bitmap is less than 32 pages, then everything works fine, until =

I try to reboot, at which point the device either (in order of=20
decreasing probability):
1. Fails just like I've outlined above.
2. Refuses to activate at all (if using LVM, you get some complaint=20
about 'expected raid1 segment type, but got NULL' or 'reload ioctl on=20
failed')
3. It works for a while, and then one of the first two things happens=20
the next time I reboot.
>
> Here's what I got from dmesg when creating a 32G LVM volume that exhibi=
ted
> this issue:
> [66318.401295] device-mapper: raid: Superblocks created for new array
> [66318.450452] md/raid1:mdX: active with 2 out of 2 mirrors
> [66318.450467] Choosing daemon_sleep default (5 sec)
> [66318.450482] created bitmap (32 pages) for device mdX
> [66318.450495] attempt to access beyond end of device
> [66318.450501] dm-91: rw=3D13329, want=3D0, limit=3D8192
> [66318.450506] md: super_written gets error=3D-5, uptodate=3D0
> [66318.450513] md/raid1:mdX: Disk failure on dm-92, disabling device.
>                 md/raid1:mdX: Operation continuing on 1 devices.
> [66318.459815] attempt to access beyond end of device
> [66318.459819] dm-89: rw=3D13329, want=3D0, limit=3D8192
> [66318.459822] md: super_written gets error=3D-5, uptodate=3D0
> [66318.492852] attempt to access beyond end of device
> [66318.492862] dm-89: rw=3D13329, want=3D0, limit=3D8192
> [66318.492868] md: super_written gets error=3D-5, uptodate=3D0
> [66318.627183] mdX: bitmap file is out of date, doing full recovery
> [66318.714107] mdX: bitmap initialized from disk: read 3 pages, set 655=
36 of 65536 bits
> [66318.782045] RAID1 conf printout:
> [66318.782054]  --- wd:1 rd:2
> [66318.782061]  disk 0, wo:0, o:1, dev:dm-90
> [66318.782068]  disk 1, wo:1, o:0, dev:dm-92
> [66318.836598] RAID1 conf printout:
> [66318.836607]  --- wd:1 rd:2
> [66318.836614]  disk 0, wo:0, o:1, dev:dm-90
>
> And here's output for a 24G LVM volume that didn't display the issue.
> [66343.407954] device-mapper: raid: Superblocks created for new array
> [66343.479065] md/raid1:mdX: active with 2 out of 2 mirrors
> [66343.479078] Choosing daemon_sleep default (5 sec)
> [66343.479101] created bitmap (24 pages) for device mdX
> [66343.629329] mdX: bitmap file is out of date, doing full recovery
> [66343.677374] mdX: bitmap initialized from disk: read 2 pages, set 491=
52 of 49152 bits
>
> I'm using a lightly patched version of 4.2.3
> (the source can be found at https://github.com/ferroin/linux)
> but none of the patches I'm using come anywhere near anything in the bl=
ock layer,
> let alone the DM/MD code.
>
> I've attempted to bisect this, although it got kind of complicated.  So=
 far I've
> determined that the first commit that I see this issue on is d3b178a: m=
d: Skip cluster setup for dm-raid
> Prior to that commit, I can't initialize any dm-raid devices due to the=
 bug it fixes.
> I have not tested anything prior to d51e4fe (the merge commit that pull=
ed in the md-cluster code),
> but I do distinctly remember that I did not see this issue in 3.19.
>
> I'll be happy to provide more info if needed.



--------------ms040903000009000007070608
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIxMTMxOTU5WjBPBgkq
hkiG9w0BCQQxQgRAhX2lw5120zzbZifzAAdPOPixRpavgbCUB8/CUMUhdNbfV3dxT6BA8G/y
MHiXhJt3B5iBDFB8SC7SSK244dHUcDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAv+ojFL9zIfj7L/nxdE6pUHcnIchkewUZNe1l9Yg8lf4lgtaWD
k3q66EUN9MkBYSc+OVcjZYTS4xj3dSa5mx3rH9cXAZIX+6QaXoCRXWA7/ZjD3dj9JsNNjmu+
+KPJ7cGKrVuAHrntAmYLRwludVOS3eTCifarT/nXI63PYtoiLp05gd8KGaC8r6NNn9xdOTB7
3sSrmxkkZJCBMgFY4BuG4EyHlL215kx/RrGtIa0weq8k88sX5yvkgSLc49XqCMoEL21+q7fI
h9bf9OA993lvHnScvGq7AOSAdBHA4I5s2YekhUO0LkJbVpVaOIOET/1aGFN5EP6I/cCOF8ZV
UB6YUUvEmbD/MtKVZxlQ4Ququl1td7Tr5FCmXihUoCeScbqKdCa206ZpM8WkqDBGQecuZBGQ
bOgSA5Vbx4oE1P8GAmxShrxJ4GbAsiojG+0E4qfwc6pboO/4c7u1UteZVKdv5AooJ53DPxUv
DXzt94H17mYs3GnYawethANekv5hqMBPoabwnPMl46FodBuka0ruXNZh1H3lg2Ms0muxbeUT
UPPMSF3kyd3SzxVQOi4zaah6iPlrX485E7lugsHNXm693dXsRBacEWJoNLLYW7CaJc3Kz6D8
3VAo5o9sYAnpvaaLXW2utg5WO/XHYSYU71HIMekiQlEas1CDGrMb9DnXcAAAAAAAAA==
--------------ms040903000009000007070608--
