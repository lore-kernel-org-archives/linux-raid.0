From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Mon, 17 Apr 2006 02:21:21 +0200
Message-ID: <62b0912f0604161721xc30e6abn27c55dcd9caefd2@mail.gmail.com>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
	 <17474.51121.178492.61143@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17474.51121.178492.61143@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> use --assemble --force

# mdadm --assemble --force /dev/md1
mdadm: forcing event count in /dev/sda1(0) from 163362 upto 163368
mdadm: /dev/md1 has been started with 5 drives (out of 6).

Oops, only 5 drives, but I know data is OK on all 6 drives.

I also know that there are bad blocks on more than 1 drive.  So I want
MD to recover from the other drives in those cases, which I won't be
able to with only 5 drives.

In other words, checking/repairing with only 5 drives will lead to
data corruption.

I'll stop and try again, listing all 6 drives by hand:

# mdadm --stop /dev/md1
# mdadm --assemble /dev/md1 --force  /dev/sda1 /dev/sdb1 /dev/sdc1
/dev/sdd1 /dev/sde1 /dev/sdf1
mdadm: /dev/md1 has been started with 5 drives (out of 6).

Ugh.  Didn't work.  Bug?

How do I force MD to raise the event counter on sdb1 and accept it
into the array as-is, so I can avoid bad-block induced data
corruption?
