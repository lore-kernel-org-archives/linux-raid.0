From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: Re: raid5 on 2.4.21 and reconstruction problem
Date: Mon, 11 Aug 2003 23:20:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308112320.49298.arekm@pld-linux.org>
References: <200308071250.18543.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200308071250.18543.arekm@pld-linux.org>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Both arrays was created under some 2.2 kernel. Resync doesn't happen=
 on=20
>>2.5.25, too.

>2.5.25 is ancient!
That was typo. I was thinking about 2.2.25. Sorry.

>2.6.0-test2 should be able to assemble it (it ignores those counts)
>but there is some data corruption bug that I am hitting in
>2.6.0-test2 that could well be raid5 related, so I'm not sure I
>would recommend that.
What about test3?

>I could probably knock up a patch to 2.4.21 in a couple of days that
>corrects the counts when an array is assembled.
I'm very interested in this patch. I can wait few days and test it befo=
re I do=20
proposed alternative method.

>Alternatively if you can boot off a rescue disk, then
>  mdadm -C /dev/md0 -l5 -c 32 -n 3 /dev/sda2 /dev/sdb2 missing
>  mdadm /dev/md0 -a /dev/sdc2

>should get you out of trouble.

>NeilBrown
--=20
Arkadiusz Mi=B6kiewicz    CS at FoE, Wroclaw University of Technology
arekm@sse.pl   AM2-6BONE, 1024/3DB19BBD, arekm(at)ircnet, PLD/Linux

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
