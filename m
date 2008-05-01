From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Sleeping hard drives in an array?
Date: Thu, 1 May 2008 10:52:12 +0200
Message-ID: <fvc0bs$7hj$1@ger.gmane.org>
References: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg Cormier <gcormier@gmail.com> wrote:
> hdparm -S240 /dev/sdX
> But I'm fairly sure they are not spinning down :( Is there some
> activity mdadm is doing in the background?

There are lots of tools out there and likely installed on normal systems
that do access disks at regular intervals:
smartd, hddtemp, probably some hal-stuff, etc. pp. Most of them do not
access disks in standby mode or can be configured to do so. But as long
as disks are active, they keep accessing them and thus reset the disks
standby timeout.
If you use bitmaps on degraded arrays, depending on your kernel version
even md could access disks at regular intervals, but this is probably
less likely than some of the above mentioned tools.


regards
   Mario
-- 
Computer games don't affect kids; I mean if Pac-Man affected us as kids,
we'd all be running around in darkened rooms, munching magic pills and
listening to repetitive electronic music.
                                  -- Kristian Wilson, Nintendo Inc, 1989

