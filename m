From: Kyle Logue <teque5@gmail.com>
Subject: Re: Wierd: Degrading while recovering raid5
Date: Wed, 11 Feb 2015 17:12:41 -0500
Message-ID: <CAP7a4UR1HzJ9AueEr1e=Zh5+p0=QgODA4=_Bp7bfQ=f2CwPhYg@mail.gmail.com>
References: <CAP7a4URzYsvw9aEd117FAs9_AE4fk1FuHQAmQQqreb3Y1yvOdg@mail.gmail.com>
	<54DB6707.5030901@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DB6707.5030901@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good news phil. Under the hypothesis that the new disk that I added
didn't fully replace my sde I omitted it from my assemble. The array
went full UUUUU, then I echo'd check > /sys/block/md0/md/sync_action

Much later it kicked out the faulty disk (previously sdc) and now i
have a _UUUU.

So hopefully this is the final question, but should I just evacuate as
much data as possible immediately? Or try to add another spare and
rebuild?

Thanks for the help,
Kyle L
