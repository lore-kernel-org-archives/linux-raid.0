From: Neil Brown <neilb@suse.de>
Subject: Re: question about bitmaps and dirty percentile
Date: Thu, 6 Aug 2009 16:21:45 +1000
Message-ID: <19066.30329.778572.603105@notabene.brown>
References: <cccedfc60907301125i2187907od5819e464de2d25a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Thursday July 30
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday July 30, jnelson-linux-raid@jamponi.net wrote:
> 
> I saw this, which just *can't* be right:
> 
> md12 : active raid1 nbd0[2](W) sde[0]
>       72612988 blocks super 1.1 [3/1] [U__]
>       [======================================>]  recovery =192.7%
> (69979200/36306494) finish=13228593199978.6min speed=11620K/sec
>       bitmap: 139/139 pages [556KB], 256KB chunk

Certainly very strange.  I cannot explain it at all.

Please report exactly what kernel version you were running, all kernel
log messages from before the first resync completed until after the
sync-to-200% completed.

Hopefully there will be a clue somewhere in there.

Thanks,
NeilBrown
