From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: Linear Raid Problems...
Date: Mon, 05 Apr 2004 10:37:21 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4070B851.6080707@tequila.co.jp>
References: <8E4E38BF6D087F4488E80ABAACA2F3F484D649@il27exm02.cig.mot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8E4E38BF6D087F4488E80ABAACA2F3F484D649@il27exm02.cig.mot.com>
To: Novak David-DNOVAK1 <David.Novak@motorola.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Novak David-DNOVAK1 wrote:

| Homer:/etc# cat /proc/mdstat
| Personalities :
| read_ahead not set9L, 906C                                    1,1
| All
| md0 : inactive sdd1[2] sdc1[1] sdb1[0]
|       0 blocks
| unused devices: <none>


interesting here is that there are no Personalities. Have you compiled
them into the kernel?

I get at least this (even without started raid)

cat /proc/mdstat
Personalities : [raid1]

has just raid1 compiled int

cat /proc/mdstat
Personalities : [raid1] [raid5] [multipath]

this one has more compiled in ...

so if you don't see this, I think he can't load the basic raid stuff and
fails because of that...

- --
Clemens Schwaighofer - IT Engineer & System Administration
==========================================================
TEQUILA\Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
http://www.tequila.co.jp
==========================================================
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAcLhQjBz/yQjBxz8RAm4XAKCpLvEZi2TLwiKyIka7F4MqzcHghgCeN+il
6YTnD2jC1FBg75JCW5omFCM=
=kaAx
-----END PGP SIGNATURE-----
