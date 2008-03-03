From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5 in sync does not populate slots sequentially, shows array
 as (somewhat) faulty
Date: Mon, 03 Mar 2008 13:34:47 -0500
Message-ID: <47CC44C7.1040304@tmr.com>
References: <47CBD62E.7040608@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47CBD62E.7040608@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Hello,
>
> Noticing the problems Tor Vestb=C3=B8 is having, I remembered that I =
have=20
> an array in a similar state, which I never figured out. The array has=
=20
> been working flawlessly for 3 months, the monthly 'check' runs come=20
> back with everything being clean. However this is how the array looks=
=20
> through mdadm's eyes:

I'm in agreement that something is odd about the disk numbers here, and=
=20
I'm suspicious because I have never seen this with 0.90 superblocks.=20
That doesn't mean it couldn't happen and I never noticed, it's certainl=
y=20
odd that four drives wouldn't be numbered 0..3, in raid5 they are all=20
equally out of sync.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
