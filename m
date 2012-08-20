From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: O_DIRECT to md raid 6 is slow
Date: Mon, 20 Aug 2012 00:42:05 -0500
Message-ID: <5031CE2D.8030600@hardwarefreak.com>
References: <502D6B0A.6090508@xs4all.net> <502DF357.8090205@hardwarefreak.com> <502E2817.8040306@xs4all.net> <502F237D.6060806@hardwarefreak.com> <502F698C.9010507@msgid.tls.msk.ru> <50305AB9.5080302@hardwarefreak.com> <5030F1C6.90205@hesbynett.no> <50317804.9010701@hardwarefreak.com> <20120820100134.22b2b056@notabene.brown> <5031C0A9.60803@hardwarefreak.com> <20120820051951.GC19235@dastard>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120820051951.GC19235@dastard>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: NeilBrown <neilb@suse.de>, David Brown <david.brown@hesbynett.no>, Michael Tokarev <mjt@tls.msk.ru>, Miquel van Smoorenburg <mikevs@xs4all.net>, Linux RAID <linux-raid@vger.kernel.org>, LKML@dastard.hardwarefreak.com
List-Id: linux-raid.ids

On 8/20/2012 12:19 AM, Dave Chinner wrote:

> Oh, you're probably complaining about that write number.

I wasn't complaining.  You know me better than that.

The cops caught me robbing a bank.  Under pressure, I pointed at you and
said "He gave me the gun and ammo!". ;)  Of course it was completely my
responsibility for shooting myself in the foot with it. :)

> Either way, the point I was making in the original post stands -
> RAID6 sucks balls for most workloads as they only do small writes in
> comparison to the stripe width of the volume....

Agreed.  Which was the point I originally made in this thread.  "We"
simply got a minor detail wrong.  It seems folks on the linux-raid list
like to split every hair 2^6 times, with extremely valid points getting
lost when the discussion drops into the weeds.

Sorry I dragged you into this Dave.

-- 
Stan

