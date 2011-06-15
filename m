From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: mark spare as active sync device?
Date: Wed, 15 Jun 2011 12:10:26 +0200
Message-ID: <20110615121026.f689e4b2.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

is it possible to mark a nearly completly synced device as active in sync?

There was failing a device shortly before a spare drive was completely
synced. I want to get the directory structure from the device.

md3 : active raid6 sdz[16] sdaf[13] sds[0] sdac[10] sdah[15] sdag[14] sdae[12] sdad [11](F) sdab[9] sdaa[17](F) sdy[6] sdx[5] sdw[4] sdv[3] sdu[2] sdt[1]
      27349202944 blocks level 6, 64k chunk, algorithm 2 [16/13] [UUUUUUU__UU_UUUU]
      [===================>.]  recovery = 98.3% (1921986020/1953514496) finish=25.9min speed=20244K/sec

/dev/sdz was the device that was inserted and is now marked as spare. Is it possible to mark sdz as active and in sync?

Is there any chance to get data from this array?

Thanks
Lars
