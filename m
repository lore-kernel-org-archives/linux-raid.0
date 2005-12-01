From: Luca Berra <bluca@comedia.it>
Subject: Re: /proc/mdstat bug: 2.6.14.2
Date: Thu, 1 Dec 2005 18:33:59 +0100
Message-ID: <20051201173359.GA29904@percy.comedia.it>
References: <200511291935.jATJZIrI013293@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200511291935.jATJZIrI013293@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 29, 2005 at 11:35:18AM -0800, Andrew Burgess wrote:
>The time and speed display for resync is wrong, the recovery numbers are fine.
>The resync is actually running at a few MB/sec.
>
>md1 : active raid6 sdn1[8](S) sde1[9] sdq1[0] sdu1[6] sdo1[5] sdaa3[4] sdab1[2] sds1[1]
>      1757815296 blocks level 6, 128k chunk, algorithm 2 [8/6] [UUU_UUU_]
>      [>....................]  recovery =  3.6% (10616704/292969216) finish=840.3min speed=5597K/sec
>      
>md0 : active raid6 sdac2[0] sdz1[4] sdy1[2] sdx1[1] sdw1[3] sdv1[5] sdr2[6]
>      1875299328 blocks level 6, 128k chunk, algorithm 2 [8/7] [UUUUUUU_]
>      [======>..............]  resync = 33.1% (103563392/312549888) finish=1.5min speed=2288625K/sec
>
>This is a amd64 x2 but running in single processor mode because of all the
>timer problems with dual cpus

do you have powernow modules loaded on this kernel? they might be
tricking your internal clock.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
