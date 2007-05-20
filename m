From: Maciej 'Agaran' Pijanka <agaran@pld-linux.org>
Subject: mdadm, raid10, and problem
Date: Sun, 20 May 2007 17:35:35 +0200
Message-ID: <20070520153535.GA563@ep09.pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids


Hello


i was trying to build raid 10 from six devices (currently loops but need
to check before i try to do same on physical drives).

and mdadm gets bit mad, 

mdadm -C -l10 -n6 /dev/loop1 /dev/loop2 /dev/loop3 missing missing
missing
produced weird result 

when tried loop missing loop missing loop missing it worked

i understand that its logical to give three pairs of devices but
content of error wasn't logical in any way

mdadm 2.6

[root@develbox /]# mdadm --create  /dev/md0 -l10 -n6 -R /dev/loop0 /dev/loop1 /dev/loop2  missing missing missing
mdadm: /dev/loop0 appears to be part of a raid array:
level=raid10 devices=6 ctime=Sun May 20 17:32:43 2007
mdadm: /dev/loop1 appears to be part of a raid array:
level=raid10 devices=6 ctime=Sun May 20 17:32:43 2007
mdadm: /dev/loop2 appears to be part of a raid array:
level=raid10 devices=6 ctime=Sun May 20 17:32:43 2007
mdadm: RUN_ARRAY failed: Input/output error
mdadm: stopped /dev/md0
[root@develbox /]#

-from dmesg:
md: bind<loop0>
md: bind<loop1>
md: bind<loop2>
md: md0: raid array is not clean -- starting background reconstruction
raid10: not enough operational mirrors for md0
md: pers->run() failed ...
md: md0 stopped.
md: unbind<loop2>
md: export_rdev(loop2)
md: unbind<loop1>
md: export_rdev(loop1)
md: unbind<loop0>
md: export_rdev(loop0)
[root@develbox /]#


ps. am not subscribed, please cc to me

best regards
maciej pijanka


-- 
agaran at pld dash linux dot org :: PLD Linux Developer [#133161]
I do not fear computers. I fear the lack of them. [Isaac Asimov]
