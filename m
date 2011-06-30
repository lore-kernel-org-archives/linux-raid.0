From: =?UTF-8?B?S2Fyc3RlbiBSw7Zta2U=?= <k.roemke@gmx.de>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Thu, 30 Jun 2011 16:21:57 +0200
Message-ID: <4E0C8685.3020806@gmx.de>
References: <4E0C5539.4030000@gmx.de> <4E0C5E47.5090604@anonymous.org.uk> <4E0C6CC4.3030506@turmel.org> <4E0C7196.1070307@gmx.de> <4E0C7B4B.7090404@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C7B4B.7090404@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil
>
> If your CPU has free cycles, I suggest you run raid6 instead of raid5+spare.
>
> Phil
>
I started the raid 6 array and get:

Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sde5[4] sdd5[3] sdc5[2] sdb2[1] sda3[0]
       13759296 blocks level 6, 64k chunk, algorithm 2 [5/5] [UUUUU]
       [=================>...]  resync = 87.4% (4013184/4586432) finish=0.4min speed=20180K/sec

when I started the raid 5 array I get

md0 : active raid5 sdd5[4] sde5[5](S) sdc5[2] sdb2[1] sda3[0]
       13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
       [=>...................]  recovery =  6.2% (286656/4586432) finish=0.9min speed=71664K/sec

so I have to expect a three times less write speed - or is this calculation
to simple ?

Karsten
