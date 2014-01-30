From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Why are reads not balanced across my RAID-1?
Date: Thu, 30 Jan 2014 15:05:10 -0500
Message-ID: <52EAB076.8070301@ubuntu.com>
References: <20140125011832.23432.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140125011832.23432.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>, keld@keldix.com, rspadim@gmail.com
Cc: linux-raid@vger.kernel.org, matthew.garman@gmail.com
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/24/2014 8:18 PM, George Spelvin wrote:
> Obviously, if I added disks and striped across them, sequential 
> performance would go up.  This is an actual RAID-10 layout. But
> it's not useful unless I buy more disks.

No, md can do raid10 on two disks, just not in the near layout.  The
offset layout with a sufficiently large chunk size mostly does what
you want.  I recently set myself up with a 3 disk array like that and
it pushes 500 MB/s using cheap, run of the mill 1 TB WD Blue drives.

The offset layout gives slightly better performance than far ( as long
as you use a sufficiently large chunk size ), and can be resized,
unlike far.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS6rB2AAoJEI5FoCIzSKrwCgUH/2ObIJbpgipuSpf1JsTLyMJk
zJnRkKISS6/1MiEtiBLRDYHhi2yL/B0S/J5jRSmgeLbAuM/q1cfF7BSOKfP52qUS
frDIRO0AtWybE/8NNiLMe6dBG1Zkfn/P+atMQwGGfy5wMWAU1DcCzq/qlv+dVkP7
VHaGuEKm/A1ySzwxnKdPTbAfe1/wRrBDeQg4leZRP9nBLA+jDWmw3oGlHW/7Aeeb
DCKKzU6+V1Hqrk8kmayh6A6D5Dp8AdPoMEj7q/I8edNX/Zp8NI/yH2wOrEkXI/xK
kiE2E0kRHyTFQ2VxU0rGKzYzE4fcjtoaDdQxHhc58/5LkUE3PTDsTyBxKn0XsHU=
=G5bT
-----END PGP SIGNATURE-----
