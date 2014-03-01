From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [md PATCH 00/10] md patches for 3.5: RAID10 reshape
Date: Sat, 01 Mar 2014 00:08:30 -0500
Message-ID: <53116B4E.50306@ubuntu.com>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 04/03/2012 01:53 AM, NeilBrown wrote:
> The following patches are now in my queue for 3.5. (I may add some
> more, but to avoid patch-bombing I sending these now as I think
> they are ready).
> 
> This is all about reshaping arrays and particularly RAID10.

I was wondering what the current status of this patch set is?  It
looks like this patch did get merged into the kernel, but mdadm does
not yet support reshaping raid10?  Does that mean that adding a drive
to a raid10 can be done by manually fiddling with sysfs?



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJTEWtLAAoJEI5FoCIzSKrwH10H/RIXXRFm8gWKC3gDE8pZtOcY
kVRMLu4OxZpT6nI4FlnanDbRMWxjTEvUehR+1ZfZu7+0QTF9e1WSUAhHHOKwpl0Q
KYZUeiDfOQjviUuTPnB4+Sfjh9CUJUjXVbvy5ZzxNxn6LnzHcLkxwhesQ6c7NLzH
oy4hQtHgRH2lzjcuuDVWJD9ZZmD2u0yOYwTt8aOCWmw6VrYnA/E0YJg9P9PrA/7m
Nfute2Xi8ulQmC3KMmM/1t8zntohynb4dX2y1KH1kB0Eb8i4WWVR3kpfWOdW0ta8
T75Hqo/zK6euJVNy9lYKNQZN1CjQJgsBDrgM+oR5tpBREI0zRzU6bn5ont12TII=
=mHgu
-----END PGP SIGNATURE-----
