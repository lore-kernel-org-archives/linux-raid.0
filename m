From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
Date: Fri, 16 Mar 2012 10:19:07 +0800
Message-ID: <CANejiEVaub35zcvkTeiJCFQaPx8kAfSLZO06x_qXyrRoOuTUiA@mail.gmail.com>
References: <20120312030412.375458948@fusionio.com>
	<alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de>
	<4F5EFEB6.4060402@kernel.org>
	<alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de>
	<CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
	<alpine.LRH.2.02.1203131521190.29286@diagnostix.dwd.de>
	<CANejiEW=a1piMYvSYM5GmtxKsWYpZj+kjnmNsNUDmW9ydDBjBw@mail.gmail.com>
	<alpine.LRH.2.02.1203140839590.28358@diagnostix.dwd.de>
	<CANejiEXP9ORKTfE4O9khaHSp-Y8yOQU1LLUD5Q5pBJOGR+A-aA@mail.gmail.com>
	<alpine.LRH.2.02.1203142101290.6232@diagnostix.dwd.de>
	<CANejiEX=-y6Kgtmfg1efqn_Ufdnn=Ls-4Nne3RYAWdt07+4o2A@mail.gmail.com>
	<alpine.LRH.2.02.1203150857190.4562@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1203150857190.4562@diagnostix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-raid.ids

2012/3/15 Holger Kiehl <Holger.Kiehl@dwd.de>:
> On Thu, 15 Mar 2012, Shaohua Li wrote:
>
>> 2012/3/15 Holger Kiehl <Holger.Kiehl@dwd.de>:
>>>
>>> On Wed, 14 Mar 2012, Shaohua Li wrote:
>>>
>>>> Maybe the discard runs slow with small size request in the disk.
>>>> please drop patch "blk: add plug for blkdev_issue_discard" and try
>>>> again.
>>>> Since
>>>> we can't do merge, the plug just introduces latency.
>>>>
>>> Tried again without the patch applied, but there is only a very sma=
ll
>>> performance increase (520->600 agains 4000 fps without discard).
>>>
>>> The benchmark creates lots of small files (2 KiB) and deletes them =
again.
>>>
>>>
>>>> if it doesn't help, please capture a blktrace when you do the benc=
hmark
>>>> and
>>>> send it to me.
>>>>
>>> Ok, I will do this tomorrow. Need some sleep :-)
>>>
>>> Thanks for your work on supporting discard in MD!
>>
>> I tried your benchmark, create 2000k 2k files and delete them and
>> follows a sync.
>> the discard runs pretty fast for both raid 0/1. So can't reproduce t=
he
>> issue. I'm using
>> a fusionio card though. I'm afraid nothing I can do till get you blk=
trace.
>>
> The blktrace is a bit large so I have uploaded it to:
>
> =A0 ftp://ftp.dwd.de/pub/afd/test/trim/trace
>
> This is while the benchmark was running. Just a reminder, md2 is
> /home under which the benchmark was running. And md2 is a raid0 of
> sda3, sdb3 and sdc3. While md1 is / and also raid0 of ada2, sdb2 and
> sdc2.
>
> There is also another blktarce when all files are deleted and note
> this is only part of it (10 min), it takes about 30 minutes to delete
> all. You can find this here:
>
> =A0 ftp://ftp.dwd.de/pub/afd/test/trim/trace2
>
> Please tell me if you need more information or what else I can do to
> help find the problem.
Looks at the blktrace:
8,0    1    47871   116.769583185   870  A   D 46042912 + 96 <- (8,3) 3=
0869280
  8,3    1    47872   116.769583560   870  Q   D 46042912 + 96 [jbd2/md=
2-8]
  8,3    1    47873   116.769584613   870  G   D 46042912 + 96 [jbd2/md=
2-8]
  8,3    1    47874   116.769585255   870  I   D 46042912 + 96 [jbd2/md=
2-8]
  8,3    1    47875   116.769585693   870  D   D 46042912 + 96 [jbd2/md=
2-8]
  8,3    1    47876   116.771985862     0  C   D 46042912 + 1 [0]
  8,0    1    47877   116.799571098   870  A   D 46040696 + 32 <- (8,3)=
 30867064
  8,3    1    47878   116.799571462   870  Q   D 46040696 + 32 [jbd2/md=
2-8]
  8,3    1    47879   116.799572459   870  G   D 46040696 + 32 [jbd2/md=
2-8]
  8,3    1    47880   116.799573176   870  I   D 46040696 + 32 [jbd2/md=
2-8]
  8,3    1    47881   116.799573637   870  D   D 46040696 + 32 [jbd2/md=
2-8]
  8,3    1    47882   116.801970911     0  C   D 46040696 + 1 [0]
  8,0    1    47883   116.801980623   870  A   D 46046568 + 88 <- (8,3)=
 30872936
  8,3    1    47884   116.801980957   870  Q   D 46046568 + 88 [jbd2/md=
2-8]
  8,3    1    47885   116.801981894   870  G   D 46046568 + 88 [jbd2/md=
2-8]
  8,3    1    47886   116.801982539   870  I   D 46046568 + 88 [jbd2/md=
2-8]
  8,3    1    47887   116.801982974   870  D   D 46046568 + 88 [jbd2/md=
2-8]
  8,3    1    47888   116.811997203     0  C   D 46046568 + 1 [0]
  8,0    1    47889   116.829566908   870  A   D 46040032 + 32 <- (8,3)=
 30866400
  8,3    1    47890   116.829567261   870  Q   D 46040032 + 32 [jbd2/md=
2-8]
  8,3    1    47891   116.829569154   870  G   D 46040032 + 32 [jbd2/md=
2-8]
  8,3    1    47892   116.829569901   870  I   D 46040032 + 32 [jbd2/md=
2-8]
  8,3    1    47893   116.829570366   870  D   D 46040032 + 32 [jbd2/md=
2-8]
  8,3    1    47894   116.831972370     0  C   D 46040032 + 1 [0]
  8,0    1    47895   116.846461610   870  A   D 46039728 + 8 <- (8,3) =
30866096
  8,3    1    47896   116.846462008   870  Q   D 46039728 + 8 [jbd2/md2=
-8]
  8,3    1    47897   116.846462911   870  G   D 46039728 + 8 [jbd2/md2=
-8]
  8,3    1    47898   116.846463530   870  I   D 46039728 + 8 [jbd2/md2=
-8]
  8,3    1    47899   116.846463984   870  D   D 46039728 + 8 [jbd2/md2=
-8]
  8,3    1    47900   116.851970109     0  C   D 46039728 + 1 [0]

there are 5 discard requests, the discard request uses 2ms, 2ms, 10ms, =
2ms, 5ms
(from dispatch to finish). this isn't fast definitely. And since
discard runs in jbd, slow
discard will impact other file operations, for example, when journal is=
 full.

So looks like this isn't the fault of my patch. curious is why discard
is fast without md
in your test. Maybe the reason is the files in a new formatted
filesystem haven't
fragmentation, so discard size is big and discard request number is
small, so total
discard time is small too. while your md filesystem might have fragment=
ation, so
discard size is small and request number is big.

Thanks,
Shaohua
