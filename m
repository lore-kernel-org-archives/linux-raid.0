From: Gordon Henderson <gordon@drogon.net>
Subject: Re: FSCK and it crashes...
Date: Tue, 10 Dec 2002 19:04:22 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0212101903260.30636-100000@unicorn.drogon.net>
References: <3DF63947.3090804@mvista.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3DF63947.3090804@mvista.com>
To: Steven Dake <sdake@mvista.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 10 Dec 2002, Steven Dake wrote:

> Gorden,
>
> I believe there is a bug in RAID in 2.4.18 which causes resyncs never to
> complete (its fixed in 2.4.19).  You might check that your drive isn't
> resyncing (cat /proc/mdstat if you see a percentage, its resyncing).
>  This may or may not be your problem, although I'd try a newer kernel.

Thanks, but we started with 2.4.20, and it crashed even after it had
finished the resync... Going to do some more tests without LVM to see if
thats getting in the way.

Gordon

