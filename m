From: Dan Egli <dan@eglifamily.dnsalias.net>
Subject: Re: 15% used but "No space left on Device"
Date: Sun, 16 Nov 2003 21:19:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FB84C69.40907@eglifamily.dnsalias.net>
References: <Pine.LNX.4.56.0311161309010.12003@nemesis.cs.yorku.ca> <3FB7CE28.6090100@eglifamily.dnsalias.net> <Pine.LNX.4.56.0311161816320.12003@nemesis.cs.yorku.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0311161816320.12003@nemesis.cs.yorku.ca>
To: Andrew Hogue <hogue@cs.yorku.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Hogue wrote:
| Hi again,
|
| Okay, so I ran fsck on the disk and it said that it had errors.  So I
| "corrected" them all and everything was fine.
|
| However, now I'm getting a different message that seems related to this
| problem.
|
| I have a set of images on this device that I'm trying to encode into a
| movie.  So I run my program on it, which simply reads in an image then
| adds it to the video file etc...
|
| This is a very large list of images, about 23000 images.
|
| Now, for some reason it works fine up to a point then dies with a bus
| error.  I check the dmesg log and low and behold I get the following
| message:
|
| attempt to access beyond end of device
| 09:00: rw=0, want=707399196, limit=488396800
|
| Weird.  I try using display on that file and sometimes it dies and
| sometimes it doesn't.  Very unpredictable.
|
| Why would the system 'think' that I'm trying to access outside of my disk
| when the file exists and is the correct size?
|
| Any ideas?


Yes, but not one you will like. When you "corrcted" the errors, you made
changes that, while LOOKING correct, actually damaged the file(s). That
is part of why I said you should backup the array before doing anything.

- --- Dan
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (MingW32)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQE/uExotwT22Jak4/4RArEiAKCAHgcR74D5K17q+61z71Oui/QvswCgtNgP
cAw4nw918oqUsVzAhThksHM=
=8AJV
-----END PGP SIGNATURE-----


