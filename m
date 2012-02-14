From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: add another disk to existing raid 0, ie grow raid 0 possible?
Date: Tue, 14 Feb 2012 11:43:30 +0200
Message-ID: <4F3A2CC2.4090101@oldum.net>
References: <4F212A59.1070008@oldum.net>	<CADNH=7GXJ0DW7K5DqSgoYYsa2eSWzE9P46R=Qrehu1pFXqnpyQ@mail.gmail.com>	<20120126215713.0c24db62@notabene.brown>	<4F21396D.7030308@oldum.net>	<20120209145054.4443a48b@notabene.brown>	<4F352541.2050207@oldum.net> <20120213090727.1d06291f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120213090727.1d06291f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello Neil,
Here is the result, I think I managed to reproduce it as it has converted the raid0 to raid4.


so commands in sequence:

mdadm --verbose --create /dev/md/mdtest --level=0 --raid-devices=2 --metadata=1.2 /dev/loop0 /dev/loop1
mdadm: chunk size defaults to 512K
mdadm: array /dev/md/mdtest started.

strace -o /tmp/foo -f mdadm --grow /dev/md/mdtest --raid-devices=3 --add /dev/loop2
mdadm: level of /dev/md/mdtest changed to raid4
mdadm: /dev/loop2 not large enough to join array
mdadm: Need to backup 3072K of critical section..
mdadm: /dev/md/mdtest: Cannot grow - need a spare or backup-file to backup critical section
mdadm: aborting level change


The 3 devices are equal sizes, all 200MB in size:

- -rw-r--r--  1 root     root     209715200 Feb 14 11:28 raid_device1.loopback
- -rw-r--r--  1 root     root     209715200 Feb 14 11:28 raid_device2.loopback
- -rw-r--r--  1 root     root     209715200 Feb 14 11:17 raid_device3.loopback


Output of mdadm -E :

http://pastebin.com/WBhgP4L5

Contents of /tmp/foo:

http://pastebin.com/jcietEaa

Let me know if you need any more information to debug this.

Thanks,
- -Nik

On 02/13/2012 12:07 AM, NeilBrown wrote:
> On Fri, 10 Feb 2012 16:10:09 +0200 Nikolay Kichukov <hijacker@oldum.net>
> wrote:
> 
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
> 
>> Hi Neil,
>> Do you think it will make sense to try to replicate using loop devices?
> 
> It certainly won't hurt.  It might not achieve anything though.
> Give it a try ... it you manage to reproduce, let me know.
> 
> Thanks,
> NeilBrown
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPOizCAAoJEDFLYVOGGjgXylEIAK0JwigUO+E+L0GqdlYoU/N8
5zdEBZ+0yu0VjsyKPAhOTz5g9348lNRPFyuQkOlGoDm3T06WxAbgo/Hh1kS2Q4IT
sWjw2w9NQI6qE0sRJPZS7Xie57M/dLVvNGUcLGvYCYTqXZQlAZbMf0tr8BCg8A6F
ddkvagi+QPyQg9NQultRhHwt10Ed6D2J1NFbnpoytoJy+27lwGfom1hmGKdtLVZG
2ZRoGtzk2yhomF8qgY4xujClZSaF7HaZc1eJ0FDDoUvQfEHEtjImSd/BbwAiUpsH
zv8aNn2Gik5v1RAHq8eOCg148J/XY/4RVD05zKj7fQqnphiwZGdirSKWv9YQCN0=
=VwH2
-----END PGP SIGNATURE-----
