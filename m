From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: wish for Linux MD mirrored raid types
Date: Sun, 08 May 2011 17:25:24 -0400
Message-ID: <4DC70A44.5050101@meetinghouse.net>
References: <20110506071752.GA22063@www2.open-std.org> <20110508181445.GB7629@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110508181445.GB7629@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> On Fri, May 06, 2011 at 09:17:52AM +0200, Keld J=F8rn Simonsen wrote:
>> I would like linux MD raid10 functionality to be part of the Linux M=
D
>> RAID1 module, and be called raid1. This is in accordance with the
> then we need rename the current raid1 functionality to 'mirror'. in
> order to avoid further confusion.
> besides, current raid10 does not support resizing, so the feature
> should be added before ditching 'mirror'
>

The current md RAID1 does exactly what RAID1 is supposed to do.

The md RAID10 is a very specific, and unique approach that has=20
similarities to, but is distinct from, RAID1+0, RAID0+1, RAID5, and RAI=
D6.

What say we leave the names alone.  Just beause one person is confused =
is no reason to further confuse things.

Just one man's opinion.

Miles Fidelman



--=20
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
