From: "JaniD++" <djani22@dynamicweb.hu>
Subject: mdadm options, and man page
Date: Tue, 17 Jan 2006 01:24:03 +0100
Message-ID: <026f01c61afc$54d40660$a400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, Neil,

Some days before, i read the entire mdadm man page.

I have some ideas, and questions:

Ideas:
1. i think, it is neccessary, to make another one mode to mdadm like "nop"
or similar, just for bitmaps, and another options, that only works with
assemble, and create (or grow) modes.

2. i think the raid5 creation virtual spare drive technique necessary to be
standalone option, to avoid more people to data lost, with re-creating the
raid5 arrays, and who did'nt read carefully the entire man.

3. i think it will be an usefull thing, set the recovery, resyncing
order(eg. from the end of the drive to the beginning) of array, or set the
"from" and "to" limits for it, or stop, restart(retry) this function, if it
is possible again.
(only experimental, it will be allow very easy to loose data.)
This is useful in very big arrays, wich takes some days to resync.
Yes, i know this caused to write the bitmap code, but i think the linux is
beautiful because it is very configurable. :-)
... i did not like the automated things, what i cannot controll....


Questions:
1. it will be possible to set/unset the --write-mostly, --write-behind
options online?
(i know, currently not.)

2. it will be possible to create a bitmap in raid5 when it is resyncing, or
recovering?

3. it is possible to set unset the clean state of the array online? (useful
for idea #3)

4. why the md did not support raid4,5 with non-persistent superblock?
I think the non-persistent superblock raid4 is very useful thing to easy
upgrade (protect) from one big legacy raid0 array to raid4 with an existing
data! :-)
At this time i need it too. :-)

Thanks,
Janos

