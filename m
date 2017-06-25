From: Hubert Reevez <hubereevez@gmail.com>
Subject: Re: can't add a larger spare for a failed smaller disk
Date: Sun, 25 Jun 2017 12:35:26 +0200
Message-ID: <CAAK+==bH6JcdtXYGhf+zJ_g1XvzKUnNEyTfpcdgDnuJ8WhmG3w@mail.gmail.com>
References: <CAAK+==bmLQ6EGm806+feV=PGp1xB7vMwtEXXD3dJZA8fHn-osQ@mail.gmail.com>
 <CAFCYAsePbzqj7=0BORYGSvQFAOY9SCDAfX1hQmj-8gH2dFj3WA@mail.gmail.com>
 <CAAK+==YbNyjFryhDmJe2Y67rcGzZKvaKX2BaEJzZTuMTN98jRw@mail.gmail.com>
 <CAFCYAsexbWzffTdouwjQQf0=ZrSx+67c3rWtHcTX9K0nZ5Uuxw@mail.gmail.com>
 <CAAK+==Y1h9GPw-5jmtnXKNPP6aYz3ezKre-MKSPvW9Sbjv7hdQ@mail.gmail.com>
 <CAFCYAsdDdBVxFuj1S_5vOTNO3KN0mqA+hjbD99Ea53AadXuMFA@mail.gmail.com> <CAAK+==YioRVH4LAYVHmfuF41+T-emBwoMawp4xBPyowYTp9_tA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAK+==YioRVH4LAYVHmfuF41+T-emBwoMawp4xBPyowYTp9_tA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to swedenlike on irc linux-raid , I did force -assemble
sd[abefg] then add sdc

Resynching now

root@Zetta:~# mdadm --add /dev/md0 /dev/sdc
mdadm: added /dev/sdc
root@Zetta:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdc[7] sdf[0] sdg[6] sdb[4] sde[3] sda[2]
      5860548608 blocks super 1.2 level 6, 512k chunk, algorithm 2
[6/5] [U_UUUU]
      [>....................]  recovery =  0.0% (582896/1465137152)
finish=209.3min speed=116579K/sec

unused devices: <none>

I will have to get some help to fine tune my mdadm , since it appears
my sdg has a wrong offset (and myabe my sdc will)

Thanks
