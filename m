From: Krzysztof Adamski <k@adamski.org>
Subject: Raid6 rebuild question
Date: Thu, 02 Feb 2012 16:16:42 -0500
Message-ID: <1328217402.9581.84.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I changed a drive in a Raid 6 array and while I'm watching the rebuild,
this is what I see from the atop command:

DSK |         sdo | busy     99% | read   397/s | write    0/s | avio    2 ms |
DSK |         sdm | busy     64% | read     0/s | write  310/s | avio    2 ms |
DSK |         sdk | busy     62% | read   577/s | write    0/s | avio    1 ms |
DSK |         sdp | busy     60% | read   579/s | write    0/s | avio    1 ms |
DSK |         sdi | busy     60% | read   584/s | write    0/s | avio    1 ms |
DSK |         sdn | busy     60% | read   578/s | write    0/s | avio    1 ms |
DSK |         sdj | busy     59% | read   587/s | write    0/s | avio    1 ms |
DSK |         sdl | busy     59% | read   580/s | write    0/s | avio    1 ms |

sdm is the new drive, all drives are identical and connected to the same
LSI controller. Is this normal or sdo is having problems?


md2 : active raid6 sdm3[8] sdl3[0] sdo3[6] sdj3[5] sdi3[4] sdp3[3] sdk3[2] sdn3[1]
      8777658240 blocks level 6, 64k chunk, algorithm 2 [8/7] [UUUUUUU_]
      [============>........]  recovery = 63.3% (926139636/1462943040) finish=190.9min speed=46850K/sec
      bitmap: 0/11 pages [0KB], 65536KB chunk


