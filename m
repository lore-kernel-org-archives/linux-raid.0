From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Re: Force RAID1 as clean
Date: Tue, 06 Jan 2004 16:21:32 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xwu85w1ab.fsf@ford.guide>
References: <yw1xn091zuwy.fsf@ford.guide>
	<001501c3d462$e3409590$0100a8c0@KARI> <3FFACAE0.9030300@steudten.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FFACAE0.9030300@steudten.com> (Thomas Steudten's message of
 "Tue,: 49:04 +0100")
To: Thomas Steudten <alpha@steudten.com>
Cc: Matthew Simpson <matthew@symatec-computer.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Steudten <alpha@steudten.com> writes:

> Matthew Simpson wrote:
>
>>>For some reason, the resync is terribly slow in Linux 2.6.0, only
>>>~1MB/s.  DMA is enabled on all disks and the individual performance =
of
>>>each disk is normal.  There are no error messages from the kernel.  =
It
>>>just doesn't seem right.
>>
>> 2.4.18 here and I'm also getting about 1MBs/sec on resynch.  :(
>
> Do you increment the values in /proc/sys/dev/raid?
> (Hope it's still there in 2.6.x)

I did, and the problem went away.  Now it's 40 MB/s.

--=20
M=E5ns Rullg=E5rd
mru@kth.se
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
