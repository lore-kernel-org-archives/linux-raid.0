From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: 800G RAID5 w/ what FS?
Date: Tue, 06 Apr 2004 09:55:57 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4072001D.2030305@tequila.co.jp>
References: <40719357.8050209@ocis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40719357.8050209@ocis.net>
To: "Jason C. Leach" <jleach@ocis.net>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jason C. Leach wrote:
| hi,
|
| I was told reiserfs does not work too well with RAID. Is this true? If
| so I'll go with ext3.  I am using a Promise SX6000 to create a 800G
| RAID5 array.

well in my opinion an FS depends on what you want to do. ReiserFS is
very good with a lot of small files (maildir eg), but I only use it on
an Hardware Raid at the moment.
I have very good experience with XFS. I run it on an LVM on an
hardwareraid and on an raid5 software raid without any problems :)
ext3 is of course a save route, thought from time to time you read about
problems with ext3 and software raid. so before you gon into production
I'd do some tests :)

- --
Clemens Schwaighofer - IT Engineer & System Administration
==========================================================
TEQUILA\Japan, 6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN
Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343
http://www.tequila.co.jp
==========================================================
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAcgAcjBz/yQjBxz8RAhlyAJ4sLbndQQ1M36RFyV4AXkpMYEgd8ACfSELK
ZyvcPzkKi9F1lIe+WSn+eZg=
=SN0e
-----END PGP SIGNATURE-----
