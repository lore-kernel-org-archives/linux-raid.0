From: William Marques <william@scinergy.com.br>
Subject: Re: Problems with invalid superblock
Date: Sat, 18 Feb 2006 00:34:07 -0200
Message-ID: <43F6879F.6080601@scinergy.com.br>
References: <43F64759.1060503@scinergy.com.br> <43F64EE5.7070408@fooplanet.com> <43F65E08.2020004@scinergy.com.br> <43F65F8E.1030505@fooplanet.com>
Reply-To: william@scinergy.com.br
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43F65F8E.1030505@fooplanet.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gil <gil@fooplanet.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Gil escreveu:
> William Marques wrote:
>> Found something interesting in syslog:
>>
>> Feb 17 21:25:27 master kernel: md: bug in file drivers/md/md.c, line 1513
>> Feb 17 21:25:27 master kernel:
>> Feb 17 21:25:27 master kernel: md:^I**********************************
>> Feb 17 21:25:27 master kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
>> Feb 17 21:25:27 master kernel: md:^I**********************************
>> Feb 17 21:25:27 master kernel: md0:
>> Feb 17 21:25:27 master kernel: md:^I**********************************
>> Feb 17 21:25:27 master kernel:
> 
> Not really.  This is the sort of thing I would post back to the
> list.  Earlier I was just pointing out that mdadm -E was for the
> components of a raid device, rather than the raid device itself.
> 
> --Gil
> 
ok, sorry abou that, I don realize tha I just not copy the list... done now.

- --
William Marques
Consultor Linux - TI
LPIC-1: LPI000058633
Scinergy Consulting Ltda.
Fone: +55 21 2224-3224
http://www.scinergy.com.br
Rio de Janeiro - Brasil
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFD9oefbwzoNUPCOg8RAntqAJwKVWzUmD/x3l6ZVujOjoHoPuULAgCfQaTS
ISGTnRcKnUUhsPy2iG7Q0EY=
=0VkN
-----END PGP SIGNATURE-----
