From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: Kicking Non-Fresh From Array
Date: Fri, 21 May 2004 17:48:41 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40ADC269.4080902@tequila.co.jp>
References: <40AD17C1.8010708@atella.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40AD17C1.8010708@atella.com>
To: Sevatio <sevatio@atella.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sevatio wrote:
| I can't figure out how to get a partition into a Raid1 array.  Syslog
| tells me "kicking non-fresh hdc6 from array".  Raidtab is set to assign
| /dev/hda6 & /dev/hdc6 to /dev/md1:
|
| raiddev       /dev/md1
| raid-level    1
| chunk-size    64k
| persistent-superblock 1
| nr-raid-disks 2
|     device    /dev/hda6
|     raid-disk 0
|     device    /dev/hdc6
|     raid-disk 1
|
| But mdstat only shows hda6 for md1.  Also, I tried raidhotadd but it
| doesn't show hdc6 as being active:
|
| md1 : active raid1 hdc6[1] hda6[0]
|       6144704 blocks [1/1] [U]
|
| How do I fix this to get hdc6 to join md1?

check what kind of partition is hdc6. I always use 'fd' [Linux raid
auto] and it works fine for me.

- --
Clemens Schwaighofer - IT Engineer & System Administration
==========================================================
TEQUILA\Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
http://www.tequila.co.jp
==========================================================
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFArcJpjBz/yQjBxz8RAlYwAKDsj9l/HH7jBNCkpTrQCvhjWbKbIQCfak9C
Ej7gv8Czwc/AxK3vguatffE=
=9Jec
-----END PGP SIGNATURE-----
