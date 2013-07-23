From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MD array keeps resyncing after rebooting
Date: Tue, 23 Jul 2013 20:52:10 +0200
Message-ID: <51EED0DA.3020901@arcor.de>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com> <CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Which MD version are you using?

What you describe looks suspiciously like the problem I tried to solve
with my patch "DDF: use existing locations for primary and secondary DDF
structure".

Please give the current git version of mdadm a try.

Martin
