From: Thomas Steudten <alpha@steudten.com>
Subject: Re: Force RAID1 as clean
Date: Tue, 06 Jan 2004 15:49:04 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FFACAE0.9030300@steudten.com>
References: <yw1xn091zuwy.fsf@ford.guide> <001501c3d462$e3409590$0100a8c0@KARI>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001501c3d462$e3409590$0100a8c0@KARI>
To: Matthew Simpson <matthew@symatec-computer.com>, mru@kth.se, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

Do you increment the values in /proc/sys/dev/raid?
(Hope it=B4s still there in 2.6.x)

Matthew Simpson wrote:

> 2.4.18 here and I'm also getting about 1MBs/sec on resynch.  :(

>>For some reason, the resync is terribly slow in Linux 2.6.0, only
>>~1MB/s.  DMA is enabled on all disks and the individual performance o=
f
>>each disk is normal.  There are no error messages from the kernel.  I=
t
>>just doesn't seem right.


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
