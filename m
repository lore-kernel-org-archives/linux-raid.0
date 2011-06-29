From: Tom De Mulder <tdm27@cam.ac.uk>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 13:55:09 +0100 (BST)
Message-ID: <alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com> <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk> <iuf6me$9us$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="140733193388032-1400123164-1309352109=:257"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iuf6me$9us$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--140733193388032-1400123164-1309352109=:257
Content-Type: TEXT/PLAIN; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 29 Jun 2011, David Brown wrote:

>> While you are mostly correct, over time even consumer SSDs will end up
>> in this state.
> I don't quite follow you here - what state will consumer SSDs end up in?

Sorry, I meant to say "SSDs in typical consumer desktop machines". The=20
state where writes are very slow.

> Have you tried any real-world benchmarking with realistic loads with a si=
ngle=20
> SSD, ext4, and TRIM on and off?  Almost every article I've seen on the su=
bject=20
> is using very synthetic benchmarks, almost always on windows, few are don=
e=20
> with current garbage-collecting SSDs.  It seems to be accepted wisdom fro=
m the=20
> early days of SSDs that TRIM makes a big difference - and few people chal=
lenge=20
> that with real numbers or real thought, even though the internal structur=
e of=20
> the flash has changed dramatically (transparent compression, for example,=
=20
> gives a completely different effect).
>
> Of course, if you /do/ try it yourself and can show clear figures, then I=
'm=20
> willing to change my mind :-)  If I had a spare SSD, I'd do the testing=
=20
> myself.

I have a set of 4 Intel 510 SSDs purely for testing, and I have used these=
=20
to simulate the kinds of workload I would expect them to experience in a=20
server environment (focused mainly on database access). So far, those=20
tests have focused on using single drives (ie. without RAID) on a variety=
=20
of controllers.

Once the drives get fuller (something which does happen on servers) I do=20
indeed see write latencies that are in the order of several seconds (I saw=
=20
from 1500=B5s to 6000=B5s), as the drive suddenly struggles to free entire=
=20
blocks, where initially latency was in the single digits.

I am hoping to get my hands on some Sandforce controller-based SSDs as=20
well, to compare, but even they show degradation as they get fuller in=20
AnandTech's tests (and those tests seem, IME, trustworthy).

My current plan is to sacrifice half the capacity by partitioning, stick 2=
=20
of them in md RAID1 (so, without TRIM) and over the next few days to run=20
benchmarks over them, to see what the end result is.


Best,

--
Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Service
+44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3QH
-> 29/06/2011 : The Moon is Waning Crescent (18% of Full)
--140733193388032-1400123164-1309352109=:257--
