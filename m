From: "Eric Wood" <eric@interplas.com>
Subject: Re: Sync rates?
Date: Wed, 12 May 2004 14:04:43 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <043b01c4384b$9abdd010$b100000a@M145Primary>
References: <00a401c4339e$7f86b340$6705a8c0@a30> <yw1xsmede4hk.fsf@kth.se> <409A94BD.40207@steeleye.com> <00cb01c433a3$64865eb0$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Original Message ----- >
> platinum:~# cat /proc/sys/dev/raid/speed_limit_min
> 1000
> platinum:~# cat /proc/sys/dev/raid/speed_limit_max
> 200000
> 
> Are these acceptable?
> 
> Jay

# echo -n 500000 > /proc/sys/dev/raid/speed_limit_max

That'll speed it up.


