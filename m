From: "Callahan, Tom" <CallahanT@tessco.com>
Subject: RE: /proc/mdstat bug: 2.6.14.2
Date: Tue, 29 Nov 2005 21:12:28 -0500
Message-ID: <0481A62A3E95A044AC20A1A45899645C06B02F2B@glc-mail-1.tessco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
References: VM 7.19 under Emacs 21.4.1
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown ' <neilb@suse.de>, "'linux-raid-owner@vger.kernel.org '" <linux-raid-owner@vger.kernel.org>, 'Andrew Burgess ' <aab@cichlid.com>
Cc: "'linux-raid@vger.kernel.org '" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 
Little off this topic, but how did you get the AMD64 x2 to run in single
processor mode? I was trying to figure this out months ago.

Thanks,
Tom Callahan

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
To: Andrew Burgess
Cc: linux-raid@vger.kernel.org
Sent: 11/29/2005 8:34 PM
Subject: Re: /proc/mdstat bug: 2.6.14.2

On Tuesday November 29, aab@cichlid.com wrote:
> The time and speed display for resync is wrong, the recovery numbers
are fine.
> The resync is actually running at a few MB/sec.
> 
> md1 : active raid6 sdn1[8](S) sde1[9] sdq1[0] sdu1[6] sdo1[5] sdaa3[4]
sdab1[2] sds1[1]
>       1757815296 blocks level 6, 128k chunk, algorithm 2 [8/6]
[UUU_UUU_]
>       [>....................]  recovery =  3.6% (10616704/292969216)
finish=840.3min speed=5597K/sec
>       
> md0 : active raid6 sdac2[0] sdz1[4] sdy1[2] sdx1[1] sdw1[3] sdv1[5]
sdr2[6]
>       1875299328 blocks level 6, 128k chunk, algorithm 2 [8/7]
[UUUUUUU_]
>       [======>..............]  resync = 33.1% (103563392/312549888)
finish=1.5min speed=2288625K/sec
> 
> This is a amd64 x2 but running in single processor mode because of all
the
> timer problems with dual cpus

Weird.....
Does it always report wrong numbers, or was this a once-off?
i.e. if you cat the file 5 times in a row, what sorts of results do
you get?

Are there any interesting kernel messages during the resync?

I'm stumped, so any extra info you might be able to provide will
probably be useful.

Thanks,
NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
