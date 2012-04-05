From: Phillip Susi <psusi@ubuntu.com>
Subject: Intel fakeraid working?
Date: Wed, 04 Apr 2012 20:56:48 -0400
Message-ID: <4F7CEDD0.9080904@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I was trying to use mdadm to activate an intel fakeraid last night and mdadm insisted on activating it as read-only.  I could not get it to switch to read-wrte.  Today I came across this bug:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/972960

It seems that the kernel OOPSed here:

void md_write_start(struct mddev *mddev, struct bio *bi)
{
	int did_change = 0;
	if (bio_data_dir(bi) != WRITE)
		return;

	BUG_ON(mddev->ro == 1);

It appears this is because it wanted to update the metadata, but the array was read-only, so I thought this might be related to what I was seeing, and there is a bug that is preventing the array from correctly going read-write.

Is the Intel fakeraid support actually working yet, or still in development?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPfO3QAAoJEJrBOlT6nu75IS4H/0nerXBIW6wnYrmZPbWZH+sr
kVTVPDAqLCvbUATicLdwsJULWwqJmsyWnXTwnm7Ssug2phmcnK8cDFzNiLY/Q3ez
A0YdMmVog74viMSfZTLVfeiPYnccuTYLeH/U3glJVJ2ISyoFQi0mH6Kd/1eEO153
4XazWr7pj/QFeBsPnYuVlojvlsHR6QwdjU3aAsObdCxWdITrnJLLRYC9S4cgqS9m
Mdh1A4dbzeyj5SrNDAX1McQD+SQDnrPR6r17Tftr9eMcLCp6mzaxYkUu+GE1r8jr
9DRqGqe0sAdNjOn4cFMRZVOaHxMjGUXxxn8tuDNS2/p99P6kdCvQO280PFHByog=
=H98J
-----END PGP SIGNATURE-----
