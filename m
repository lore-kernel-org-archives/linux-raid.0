From: "Ewan Grantham" <ewan.grantham@gmail.com>
Subject: Reconstructing - Really, or am I up a creek?
Date: Fri, 17 Mar 2006 07:45:36 -0600
Message-ID: <6d5bedd80603170545l5f7e8fdak7089d2a0decd30e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Had a drive die last night in the middle of an e2fsck of my md0 array.
Did a shutdown, and now when I try to bring up the array in degraded
mode I get:

md: bind<cobd4>
md: bind<cobd5>
md: bind<cobd6>
md: bind<cobd8>
md: bind<cobd3>
md: md0: raid array is not clean -- starting background reconstruction
raid5: device cobd3 operational as raid disk 0
raid5: device cobd8 operational as raid disk 5
raid5: device cobd6 operational as raid disk 3
raid5: device cobd5 operational as raid disk 2
raid5: device cobd4 operational as raid disk 1
raid5: cannot start dirty degraded array for md0
RAID5 conf printout:
 --- rd:6 wd:5 fd:1
 disk 0, o:1, dev:cobd3
 disk 1, o:1, dev:cobd4
 disk 2, o:1, dev:cobd5
 disk 3, o:1, dev:cobd6
 disk 5, o:1, dev:cobd8
raid5: failed to run raid set md0
md: pers->run() failed ...


Does the background reconstruction mean that it's doing something to
fix the problem, or am I in a really bad place? If the latter, any
suggestions on how I can recover my data?

TIA,
Ewan
