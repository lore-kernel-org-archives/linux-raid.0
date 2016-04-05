From: Noah Beck <noah.b.beck@gmail.com>
Subject: Re: recovery from selinux blocking --backup-file during RAID5->6
Date: Tue, 5 Apr 2016 11:01:38 -0400
Message-ID: <CAFAW0zwaOjbhneYbSQ248h6RkZApcb7LT8Qpg-ggkGXMpJJ2tA@mail.gmail.com>
References: <CAFAW0zxisX2Db_YdJxtNpF4YKayy=AnKnWcGdAgw6piy1Jjyng@mail.gmail.com>
	<57039E1F.3060307@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57039E1F.3060307@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 5, 2016 at 7:14 AM, Wols Lists <antlists@youngman.org.uk> wrote:
> DO YOU HAVE A BACKUP :-)

There are three categories of stuff on this array:
1) my own pictures and home videos, which are backed up to crashplan's
servers.  So they're available and current but incredibly inconvenient
to get to through my 1.7Mbps DSL (yes, DSL exists in 2016).
2) local crashplan backups from other computers in the house.  If I
lose this then crashplan just re-dumps the data from its source again.
3) mythtv recordings of shows going back many years.  This is ~2TB by
itself and since the aforementioned DSL is my automatic backup path,
and I don't feel I lose much if it dies, it's not backed up.
Primarily my wife wants these kept, so for domestic harmony I'll need
to find 2TB elsewhere to dump this to before I do anything
experimental.

> Thing is, when one drive fails, it should be ringing alarm bells that
> another one is on its last legs - these things have an annoying habit of
> failing in bunches. Which says that you really need a *second* spare
> drive handy - is the rebuild going to tip one of your live drives over
> the edge? I'd say the chances of you ending up with a 5-device raid-6
> with one device failed is a lot higher than you'd like :-(

Quite true.  That's why I wanted to switch to RAID6 in the first
place.  This is an incredibly old array, dating back a little over 10
years.  All of the original drives have been replaced (with larger
ones) along the way and there have been a number of plain old failed
drives that had to be replaced as well.  Having no redundancy
available during the rebuild is a nail-biting experience I want to
stop having.  :)

Noah
