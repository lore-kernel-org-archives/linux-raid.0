From: "Tomi Orava" <tomimo+linux-raid@ncircle.nullnet.fi>
Subject: Re: Raid1 recovery problem - need help!
Date: Fri, 26 Sep 2003 11:14:54 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <13800.194.237.142.24.1064564094.squirrel@ncircle.nullnet.fi>
References: <40408.194.237.142.24.1064555851.squirrel@ncircle.nullnet.fi><16243.55544.424789.503682@notabene.cse.unsw.edu.au><61251.194.237.142.24.1064557502.squirrel@ncircle.nullnet.fi><16243.57487.124068.470173@notabene.cse.unsw.edu.au><17620.194.237.142.24.1064560221.squirrel@ncircle.nullnet.fi>
    <16243.61083.69286.766387@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16243.61083.69286.766387@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil,

Thank you, the last command was able to get the RAID1+0 running
as needed. Unfortunately, the re-assembled disc is not functional.
However, I still wonder if I have made a mistake in figuring out the
proper failed disc (based on your comments) ... Therefore, I'll have
to switch the discs as soon as I get back to home and check if I can
get anything else from the raid-device with your incstructions
(as neither of the discs are absolutely dead, one of them just
hangs the machine completely sooner or later ie in 5mins or 1h).

I'm also wondering, how it can be that a single IDE-disc (in this
case IBM 60GXP or 75GXP don't know which one for sure) is able to
halt the whole machine ... I have 6 discs connected to that server
and they are all the only drives in their own channel (no slaves).
Four of the drives are connected to HPT374-chip and two more to
Sil680 PCI-card. I don't really expect any solution for this question,
I'm more or less just wondering if anyone else has had similar
problems with their hardware ?

> It should assemble successfully, but I make not promises about what
> sort of data will be on them.

Thank you for your time Neil!

Sincerely,
Tomi Orava

PS. I wonder if there exists any problem solving examples about real life
    cases in any of the docs (HOWTO, man-page etc).
    Perhaps it might be helpful to some one if I just gather up
    the mails related to this case and put them on the web for example ...
    even though every problem has little bit different environment &
    setup, but it might still help in deciding which commands to run
    and which ones to avoid (in order to not lose data by mistake).







