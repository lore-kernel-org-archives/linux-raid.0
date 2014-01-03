From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 20:02:09 -0500
Message-ID: <52C60C11.30906@ubuntu.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com> <52C5B9AE.6050901@ubuntu.com> <52C5F335.9060909@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C5F335.9060909@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, joystick <joystick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/02/2014 06:16 PM, Stan Hoeppner wrote:
> Thank you for this information.  Now, if I actually had a 4K drive
> in my hands, and plugged it in, directly formatted it with XFS, no
> partitions, would the LBA addressing be 4K or 512B?  Or would I
> need to tweak kernel parameters?  Or possibly rebuild my kernel to
> support 4K sectors?

Addressing would be in 4k sectors, no need for tweaking.  You can see
it in action with the scsi_debug module if you don't have the actual
hardware.

> It's not relevant because you don't create an md RAID set from
> CD-ROM.

Well the context wasn't specifically for md; you claimed linux did not
support non 512 byte sectors full stop.  And you *can* build an md
raid on top of cd/dvd-rw, though obviously that's a little nutty.

> IIRC, there was a lengthy discussion about this on mm back when
> some folks wanted to use 16K-4GB pages on Itanium, and later 2M
> pages on x86-64, to cut down on the amount of memory required for
> page tables and to increase performance for big memory workloads.
> As I recall the arguments for continuing to use 4K pages across the
> world of Linux, regardless of architecture capability, and to NOT
> make it configurable as in HP-UX, were, paraphrasing:

Some archs don't support 4k pages at all.

> 1.  The kernel manipulates "everything" in pages so we need
> consistency 2.  While larger pages saves page table space and
> increases throughput for large memory intensive workloads, it
> causes more waste in other structures and increases bandwidth
> demands for data that are smaller than the page size
> 
> So, IIRC, it was decided that the page size would remain 4K
> basically forever.  So while it is *technically* possible to have a
> larger page size in Linux, it is absolutely not supported by the
> kernel team, nor any distro kernel, AFAIK.

Yep, that's why the default on those archs that have a choice is still
4k, but some do give the option for larger.  If you scan the ext4 and
md mailing lists you should find a few discussions of people doing
this, or just using larger block sizes on archs that only support
larger page sizes.

> And I'd guess a whole host of things will likely break as a result
> if you don't correctly modify much of the kernel source before
> running make.  See above.

Nope; otherwise it wouldn't be a Kconfig option.  Remember, the kernel
had to grow support for non 4k pages to work at all on archs that
don't support them.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSxgwRAAoJEI5FoCIzSKrwVBIH/2XxI7Pz7pb5ojV94Xg7om2Y
drEebKn5N+QFXQGXkMZFknFSDGuv4l/KgNmPbU43ntXmAi/U+HyepMtFl4K4tPVd
lgSxNE7oikEMgHV5mKa4Ic0iB46AUp7cuhvyGe3FVxC+co9+J8hWgr11iYCCP2ra
9d7TT2hQEHELSvzWVoYWbh7ndV9ZfB5LC6dsRlqu0OKPlkX5xg/H7jlEgpqb0/Uc
ebJ4CidYtKVMsW5My3K7uG1T4uZoB6QTNEDaYzfJjw+5KAKAR60TZXttADt670yk
BPpU55UbFZTBgUyKIuYsxIZ2mgZKNTd3BT4jWOb+J5Z3+KPbN/nuHhAWqwIE+24=
=6YGJ
-----END PGP SIGNATURE-----
