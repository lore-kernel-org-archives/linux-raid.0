From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
     Linux
Date: Wed, 09 Jun 2004 16:01:43 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C6B5D7.7060801@tequila.co.jp>
References: <40498.194.60.85.4.1086343953.squirrel@194.60.85.4> <40C346A6.1000001@xss.co.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40C346A6.1000001@xss.co.at>
To: Andreas Haumer <andreas@xss.co.at>
Cc: Robin Bowes <robin-lists@robinbowes.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andreas Haumer wrote:
| Hi!
|
| Robin Bowes wrote:
|
|>>On Fri, June 4, 2004 7:29, Neil Brown said:
|>>
|>>
|>>> - Further support for partitionable arrays included "--auto=" option
|>>>   and "auto=" config file entry which instructs mdadm to create the
necessary
|>>>   device files after allocating an unused array number.
|>>
|>>
|>>Neil,
|>>
|>>I am interpreting this to mean that I can create, for example, a
large (e.g. 1TB) RAID5
|>>array and create smaller partitions (/home, /usr, etc) on top of the
RAID5 array? Is
|>>this correct?
|>>
|
| Hm.
| Why would anyone use this, given that we can put LVM on
| top of SW-RAID?

Well I'd say to leave out one area of problems. LVM might get buggy or
cause troubles. And if you can create partitions in a SW raid you can
avoid that.

eg on a firewall I want only real necessary software and LVM is
definitly not one of them ...

- --
Clemens Schwaighofer - IT Engineer & System Administration
==========================================================
TEQUILA\Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
http://www.tequila.co.jp
==========================================================
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAxrXWjBz/yQjBxz8RAnu/AJ0YlAnEXGxK3hBiGmSWJiOfT3O+rQCgheXZ
V5DTW6ESA7M8W9ZbUklefd8=
=jwFK
-----END PGP SIGNATURE-----
