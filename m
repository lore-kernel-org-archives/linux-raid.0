From: "TheGerwazy ." <gerardlesiuk@gmail.com>
Subject: Re: Mdadm with data offsets
Date: Tue, 15 Dec 2015 15:11:08 +0100
Message-ID: <CAH_hVdqS__=hNYurAWOvY8Gig-DqHGvbvwEfPffi4GKFxEWyrw@mail.gmail.com>
References: <CAH_hVdp4mGE-AZ1ww81u9vS0xri4xR+LrpaRSbaUb6VRohZ_Rg@mail.gmail.com>
	<566E0440.70801@turmel.org>
	<566E05B2.20803@turmel.org>
	<CAH_hVdo43dSuaeJT-QGN14LhiRnR1zYVFwqvueV6vxthHYYU9g@mail.gmail.com>
	<566EBC38.7060205@turmel.org>
	<CAH_hVdqMdrPTAz1LcDzZNDMdGKFOpwo32mh0E+mFZtcCBEBqJg@mail.gmail.com>
	<56701944.1040505@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56701944.1040505@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2015-12-15 14:44 GMT+01:00 Phil Turmel <philip@turmel.org>:
> On 12/15/2015 06:30 AM, TheGerwazy . wrote:
>
>> The main problem is the data offsets are not stored elsewhere than in
>> superblock. I have some drives from debian 6.0.5 and some were changed
>> in debian 7.5. In 6.0.5 default data offset was at 2048 sector while
>> int 7.5 it is 262144.
>
> There have been other defaults, and various adjustments to the
> algorithms that handle special cases.  The purpose of the superblock is
> to store the data needed by the features supported.  Where else
> would/could you store this information?
>
maybe mdadm.conf, maybe syslog ?
It the same problem like partitions, ext3 superblocks
We need only a few parameters to recover whole array - some of them we
could guess.
Meybe its a good idea to spare some backups of mdadm superblock like in EXT3 ?

Even though mdadm is, in my opinion, reliable system and I suggest it
to my clients because of easy recovery.

> This highlights why --create is such a terrible way to recover an array,
> and highlights the danger posed by well-intentioned bloggers who
> cavalierly suggest using it.
>
> Pretty much everyone who comes here for advice *before* trying --create
> has been successfully helped.  The results after --create are decidedly
> mixed.

Due to that there are production systems, sometimes there is no time
to wait even an hour for advice - your boss would ask you "I need my
data, why you are waitng ?"
Another problem is when you are asking on the Internet - you sometimes
receive completly wrong advice what lead you to losing the data...

>
>> Thanks for Phil
>
> You're welcome.
>
> Phil
>
Best regards, Gerard
