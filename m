From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: MD on raw device, use unallocated space anyway?
Date: Fri, 10 Jan 2014 20:38:13 +0000
Message-ID: <CADNH=7E3X7nbNC333==kN4X51=jAGJ4gF+qC_OX1uJ=GyUmR=g@mail.gmail.com>
References: <CADNH=7H2E5J3MPyGt4YHHK8wLzhizJLmdos0G60OE1qEwvBOKg@mail.gmail.com>
	<BLU0-SMTP3004D13A23660A4859D816298B30@phx.gbl>
	<CADNH=7FRJwC+N8dTfOgbXRxcVa0Drcrptv=tmXY33mz25zdgYg@mail.gmail.com>
	<BLU0-SMTP163A53F7E505381E9CB2F2598B30@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP163A53F7E505381E9CB2F2598B30@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10 January 2014 20:10, Wilson Jonathan <piercing_male@hotmail.com> wrote:
>
> In that case the answer would be no. However if fail/remove the 3TB
> drive, then partitioned the drive as 2TB and 1TB and then added the 2TB
> partition back into the array then you can use the 1TB on its own...
> just as long the "2TB" partition is the same size as the 2TB drives (or
> slightly bigger) then it should all work nicely.
>
>

Thanks, that confirms my suspicions. I wanted to avoid this (as a
rebuild would be required) but it's the only way, I suppose. Unless I
upgrade to 3TB all around and gain some storage.

Cheers,
Mathias
