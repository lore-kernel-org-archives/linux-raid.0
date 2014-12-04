From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Thu, 04 Dec 2014 14:29:03 -0500
Message-ID: <5480B5FF.5050407@ubuntu.com>
References: <loom.20141031T141939-473@post.gmane.org> <5455A35C.2060000@turmel.org> <loom.20141103T151703-83@post.gmane.org> <5458FC2A.1050308@turmel.org> <545CEDFB.6060806@gautschi.net> <545D8FBA.9090701@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <545D8FBA.9090701@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "P. Gautschi" <linuxlist@gautschi.net>
Cc: Vince <stuff@hagenhuegel.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/7/2014 10:36 PM, Phil Turmel wrote:
> However, if the device with the bad sector is trying to recover
> longer than the linux low level driver's timeout, bad things^TM
> happen. Specifically, the driver resets the SATA (or SCSI)
> connection and attempts to reconnect.  During this brief time, it
> will not accept further I/O, so the write back of the reconstructed
> data fails.  Then the device has experienced a *write* error, so MD
> fails the drive.  This is the out-of-the-box behavior of
> consumer-grade drives in raid arrays.

What?  During the recovery action ( reset and retry ), a write being
issued to the drive should just sit in the request queue until after
the drive finishes being reset; it should not just be failed outright.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUgLX+AAoJENRVrw2cjl5RHb4H+wWzuTFekQMwIoX7Vov5QjLh
XyEmgbwqgtdcnsbQqtnNiQK0k8KVxQDW3xzWkB30PkOjWMfldES3dRjFXuNbZ0r1
FnJeIYbChFBnfJLp/BqHHOnL5YHD81HvENJ4M/OW6t9SpSiFuOieFe7WTEwHoh5t
t9v/J0+x84CQu1q/AF7FRMkLE1fYhZieAMLTyKhbo5TmMm5XSP8eXumMCz+PXmvV
tVN6rYejSozl1wfwa0l4N9jwkyYWLgbzFRIR7PuQNacywFyLhg0WtIPnqjNV6YuL
rAl5VBFbHEn6BwklgxDWkzSIuOIt2ce6KIE0JZtqTGlDajhSUM+ojTPALLFcmLE=
=4mKS
-----END PGP SIGNATURE-----
