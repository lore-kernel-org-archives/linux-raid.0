From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Building a new raid6 with bitmap does not clear bits during resync
Date: Thu, 08 Nov 2007 17:56:05 +0100
Message-ID: <87lk98ad7e.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have created a new raid6:

md0 : active raid6 sdb1[0] sdl1[5] sdj1[4] sdh1[3] sdf1[2] sdd1[1]
      6834868224 blocks level 6, 512k chunk, algorithm 2 [6/6] [UUUUUU]
      [====>................]  resync = 21.5% (368216964/1708717056) finish=448.5min speed=49808K/sec
      bitmap: 204/204 pages [816KB], 4096KB chunk

The raid is totally idle, not mounted and nothing.

So why does the "bitmap: 204/204" not sink? I would expect it to clear
bits as it resyncs so it should count slowly down to 0. As a side
effect of the bitmap being all dirty the resync will restart from the
beginning when the system is hard reset. As you can imagine that is
pretty anoying.

On the other hand on a clean shutdown it seems the bitmap gets updated
before stopping the array:

md3 : active raid6 sdc1[0] sdm1[5] sdk1[4] sdi1[3] sdg1[2] sde1[1]
      6834868224 blocks level 6, 512k chunk, algorithm 2 [6/6] [UUUUUU]
      [=======>.............]  resync = 38.4% (656155264/1708717056) finish=17846.4min speed=982K/sec
      bitmap: 187/204 pages [748KB], 4096KB chunk

Consequently the rebuild did restart and is already further along.


Any ideas why that is so?

MfG
        Goswin
