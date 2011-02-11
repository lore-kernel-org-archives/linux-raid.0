From: Christian <cjs703@gmail.com>
Subject: Re: RAID6 array won't start
Date: Fri, 11 Feb 2011 17:36:08 -0500
Message-ID: <AANLkTi=em0Wkj48SOECZqSuyJ01AwDnDdE76aQPzWiTp@mail.gmail.com>
References: <AANLkTimLfJHc2waPkvjUXn=mewc37qkCd-r0GG4k=e-D@mail.gmail.com>
	<AANLkTi=dtMbuszU3x_hGduN-y5ATbgD0tgby_2mj4YsH@mail.gmail.com>
	<20110212074904.41e113ed@notabene.brown>
	<AANLkTikmCmutS_96PNYR0RKAv07cG5Vje0kyzzQ7U9rd@mail.gmail.com>
	<20110212083224.6b1c2cee@notabene.brown>
	<AANLkTi=Y7zf9v6dobfWj-z97FSfkVk2FpWT9Yi4MMKMr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Y7zf9v6dobfWj-z97FSfkVk2FpWT9Yi4MMKMr@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here it is again, there were a few other messages in there at the beginning.

[70745.855861] md: md1 stopped.
[70745.859303] md: bind<sdm1>
[70745.859576] md: bind<sdr1>
[70745.859720] md: bind<sds1>
[70745.860265] md: bind<sdq1>
[70745.860428] md: bind<sdk1>
[70745.860680] md: bind<sdf1>
[70745.860839] md: bind<sdg1>
[70745.860986] md: bind<sdl1>
[70745.861169] md: bind<sde1>
[70745.861359] md: bind<sdt1>
[70745.861407] md: kicking non-fresh sds1 from array!
[70745.861411] md: unbind<sds1>
[70745.870570] md: export_rdev(sds1)
[70745.870598] md: kicking non-fresh sdm1 from array!
[70745.870602] md: unbind<sdm1>
[70745.882561] md: export_rdev(sdm1)
[70745.883324] md/raid:md1: not clean -- starting background reconstruction
[70745.883333] md/raid:md1: device sdt1 operational as raid disk 1
[70745.883335] md/raid:md1: device sde1 operational as raid disk 9
[70745.883337] md/raid:md1: device sdl1 operational as raid disk 8
[70745.883339] md/raid:md1: device sdg1 operational as raid disk 7
[70745.883340] md/raid:md1: device sdf1 operational as raid disk 6
[70745.883342] md/raid:md1: device sdk1 operational as raid disk 5
[70745.883344] md/raid:md1: device sdq1 operational as raid disk 4
[70745.883345] md/raid:md1: device sdr1 operational as raid disk 2
[70745.884038] md/raid:md1: allocated 10572kB
[70745.884057] md/raid:md1: cannot start dirty degraded array.
[70745.884065] RAID conf printout:
[70745.884066]  --- level:6 rd:10 wd:8
[70745.884068]  disk 1, o:1, dev:sdt1
[70745.884069]  disk 2, o:1, dev:sdr1
[70745.884070]  disk 4, o:1, dev:sdq1
[70745.884072]  disk 5, o:1, dev:sdk1
[70745.884073]  disk 6, o:1, dev:sdf1
[70745.884074]  disk 7, o:1, dev:sdg1
[70745.884076]  disk 8, o:1, dev:sdl1
[70745.884077]  disk 9, o:1, dev:sde1
[70745.884370] md/raid:md1: failed to run raid set.
[70745.884372] md: pers->run() failed ...
