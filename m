From: Dan Egli <dan@eglifamily.dnsalias.net>
Subject: Re: Kernal Panic when booting redhat.  Raid devices mount fine underKnoppix
Date: Thu, 11 Dec 2003 16:26:35 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FD8FD2B.60200@eglifamily.dnsalias.net>
References: <3FD7A643.7060602@hosttuls.com> <3FD822D4.2030501@ratnet.stw.uni-erlangen.de> <3FD8ECA9.9080209@hosttuls.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FD8ECA9.9080209@hosttuls.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Brandon Evans wrote:

| Norman Schmidt wrote:
|
|> Brandon Evans schrieb:
|>
|>> The Raid devices mount fine
|>> under knoppix 3.3, but when I try to boot Redhat 7.3, the servers can
|>> not read the superblock on the root device (/dev/md1), so the system
|>> panics.
|>> This has happened on 2 servers so far.
|>
|>
|>
|> What partition types do the partitions hda1 hda2 hdd1 hdd2 have?
|>
| All the partitions are ext3
|
|

I think he was referring to the partiton type code (i.e. linux native, linux
rain, linux raid autodetect, etc....)


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (MingW32)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQE/2P0qtwT22Jak4/4RAgfUAKCSp41RGj1TbzT5eCQVaKvINyyKMQCfVMQm
lg3jg+eHf9+y5pmAW4T0v1M=
=Wl99
-----END PGP SIGNATURE-----


