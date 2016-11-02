From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Issue with growing RAID10
Date: Wed, 2 Nov 2016 22:00:22 +0100
Message-ID: <20161102210022.GA19707@metamorpher.de>
References: <CAANLjFrK25fUjMpif6m7y3PZ0phNa_zVLFWUVs2Yj1PtbkA_Qg@mail.gmail.com>
 <20161102181923.GA21325@www5.open-std.org>
 <CAANLjFqqTvs0Uh1R6Bvk9FyQUgQqhj+48uC4iiut_A3Uh6j6DA@mail.gmail.com>
 <20161102194842.GA25173@www5.open-std.org>
 <CAANLjFpQ-s4E3dKmaEEp0DcWaSQx21-Leafukir6idET++zMsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFpQ-s4E3dKmaEEp0DcWaSQx21-Leafukir6idET++zMsg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 02, 2016 at 01:56:02PM -0600, Robert LeBlanc wrote:
> Yes, we can have any number of disks in a RAID1 (we currently have
> three), but reads only ever come from the first drive.

Only if there's only one reader. So it depends on what activity 
there is on the machine. 

> We just need the option to grow a RAID10 like we can with RAID1.

Patches welcome, I'm sure? ;-)

> Basically, we want to be super paranoid with several identical copies 
> of the data and get extra read performance.

You could put RAID on RAID and thus achieve other modes but not sure 
if it's worth the overhead or even applies in any way to your use case 
and using non standard setups always comes with its own pitfalls.

RAID 1, with RAID0 on top, three disks ABC, two partitions ab,
different disk order.

  A B C
a 1 2 3
b 3 1 2

Three RAID 1 md1, md2, md3, (and md0 a RAID-0 on top).

You can grow it.

  A B C D
a 1 2 3 ?
b 3 1 2 ?

  A B C D
a 1 2 3 ?
b 3 1 2 3

md3 has 3 disks temporarily here.

  A B C D
a 1 2 3 4
b 4 1 2 3

md4 is new, to be added to md0.

Three copies? Same thing with three partitions.

Will it help any or make things worse? I dunno.
Have to be careful to make md0 assemble last.

Could also be RAID5 on top instead of RAID1.
That's even stranger though.

Regards
Andreas Klauer
