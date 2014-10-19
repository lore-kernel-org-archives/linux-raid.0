From: Per-Ola Stenborg <per-ola@stenborg.me>
Subject: Re: Multiple drive failure after stupid mistake. Help needed
Date: Sun, 19 Oct 2014 17:56:21 +0200
Message-ID: <5443DF25.3020702@stenborg.me>
References: <54438839.9080309@stenborg.me>	<alpine.DEB.2.02.1410191253010.30853@uplift.swm.pp.se>	<5443B55C.7000208@stenborg.me> <CAFE24U0GKPhkYe1faCBWohimJYL4O_PBYOJ+aLa_mSMKQCGGhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFE24U0GKPhkYe1faCBWohimJYL4O_PBYOJ+aLa_mSMKQCGGhw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Weedy <weedy2887@gmail.com>
Cc: linux-raid@vger.kernel.org, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

Weedy skrev 2014-10-19 15:41:
>
> Is sdb in another array when you try to assemble?
> Is /proc/mdstat empty while you're trying this?
>
No, here is the output

cat /proc/mdstat
Personalities :
md0 : inactive sdd[2](S) sdb[0](S) sde[4](S) sdc[1](S)
       7814054240 blocks super 1.2

unused devices: <none>

there is only one array in this machine.

/Per-Ola

