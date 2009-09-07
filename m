From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: Array Power Management
Date: Mon, 7 Sep 2009 06:37:16 -0700 (PDT)
Message-ID: <883434.71116.qm@web55807.mail.re3.yahoo.com>
References: <292245.77763.qm@web55804.mail.re3.yahoo.com> <70ed7c3e0909070257y4bec456h6de9cc6d2981c8ce@mail.gmail.com> <20090907125522.GL1933@hamsu.tarvainen.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090907125522.GL1933@hamsu.tarvainen.info>
Sender: linux-raid-owner@vger.kernel.org
To: Tapani Tarvainen <raid@tapanitarvainen.fi>, "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You don't needo to unmount it: just leave it mounted, and it will aut=
omatically spin up when accessed.
> I've been doing just that with a backup (rsnapshot) server for a some=
 time, works just fine.

That's great news, I was hoping there would be something simple.

> In my case the total power consumption went down by over 50%
(th> e disks stay powered down by about 85% of the time).

I don't have my figures here at the moment, but I'm hoping to save a bi=
g chunk like that too. I'm spinning 12 x 320GB disks on my file server,=
 15 x 500GB disk on one media server, and 7 x 1TB disks (and climbing -=
 Got to lovr array expansion) on my new media server. Since it's really=
 only mainly in use between 5pm and midnight, being able to spin down t=
he disks would be a huge plus (or rather, minus on the electric bill). =
I had considered just shutting down the server, but I'm probably going =
to be (re)installing MythTV when .22 is released, so one (or more) of t=
he servers will end up being storage for that, so I would never really =
know when the array is going to be needed.

> I simply do it with every individual disk of the array.

I was tempted to try that, but I wasn't sure if that would cause issues=
 with md or not. I did some googling - found quite a bit on spinning do=
wn single drives, but noone had really=A0anything to say about arrays (=
maybe I should have binged instead...:) )


Thanks to all for the suggestions.

--=20
Tapani Tarvainen
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html



     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
