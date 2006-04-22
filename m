From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 23:17:40 +0200
Message-ID: <62b0912f0604221417g3f539b9aub9c4fa82ab78faaf@mail.gmail.com>
References: <444A7C99.80006@abhost.net>
	 <62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>
	 <444A8D04.20809@abhost.net>
	 <62b0912f0604221322k25c96c37q2bee9361a6316c1b@mail.gmail.com>
	 <444A92CF.70401@abhost.net>
	 <62b0912f0604221338m6b9fc06do61d78ffa622523bc@mail.gmail.com>
	 <444A9841.8070202@abhost.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444A9841.8070202@abhost.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan <jrs@abhost.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jonathan wrote:
> /dev/md0               591G    54G   507G  10% /md0

Hrm.  Have you been hassling us for a mere 54G worth of data?
(Just kidding :-D.)

> now I'm doing a:
> (cd /md0 && tar cf - . ) | (cd /virtual/recover/ && tar xvfp -)

I wonder - if you have the disk space, why not take David Greaves'
advice and create a backup of the individual disks before fiddling
with md superblocks?

Anyway, a quick cheat sheet might come in handy:
* Hot-add a disk to an array (outdated raid data on that disk won't be used):
  # mdadm /dev/md1 --add /dev/etherd/e0.xyz

* Check that parity is OK for an entire array:
  # echo check > /sys/block/md1/md/sync_action

* Manually start a resync:
  # echo repair > /sys/block/md1/md/sync_action

* Experiment with MDADM by using sparse files:
  # dd if=/dev/zero of=sparse0 bs=1M seek=200000 count=1
  # dd if=/dev/zero of=sparse1 bs=1M seek=200000 count=1
  # dd if=/dev/zero of=sparse2 bs=1M seek=200000 count=1
  # dd if=/dev/zero of=sparse3 bs=1M seek=200000 count=1
  # losetup /dev/loop0 sparse0
  # losetup /dev/loop1 sparse1
  # losetup /dev/loop2 sparse2
  # losetup /dev/loop3 sparse3
  # mdadm -C /dev/md5 -c 32 -p left-a -n 4 -l 5 missing /dev/loop{1,2,3}

> thank you thank you thank you thank you thank you thank you

np.
(wait, does that mean I won't get my money? ;-))
