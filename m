From: Francois Barre <francois.barre@gmail.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Thu, 5 Jan 2006 18:50:17 +0100
Message-ID: <fd8d0180601050950p797d85d0p@mail.gmail.com>
References: <200601051732.k05HWOYT000687@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200601051732.k05HWOYT000687@cichlid.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Another feature of LVM is moving physical devices (PV). This makes it
> easier to grow your enormous fs because it allows you to remove disks.

Thanks for the tip, didn't think of it this way...

[...]
> I haven't ever done this, just read about it. Also, maybe when md
> allows growing raid5/6 this will be handled by md.
>

Well, that's what I am counting on since the beginning of my interrest for md...
Indead, LVM would be a good alternative to the growth capability of md
anyway... Although I would prefer a pure md extension to the raid...

Well, anyway, removing drives is (for me) a little out-of-topic,
because the system will be entropic : loads of data will come in, none
will get out... Removing a drive would only mean the drive is dead.
