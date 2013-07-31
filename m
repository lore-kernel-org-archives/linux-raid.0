From: Francis Moreau <francis.moro@gmail.com>
Subject: question about mdmon --takeover
Date: Wed, 31 Jul 2013 16:30:34 +0200
Message-ID: <CAC9WiBgFPSeKGBYxYCkw8DHk4dS6=aBhCeiMGgkj2eNgtY0asw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

I thought that using "--takeover" would hint mdmon to replace existing
mdmon process, and therefore the old one would exit somehow.

However after several "mdmon --takeover" I can see this:
 $ ps aux | grep dmon
root       233  0.0  0.2  80388 10752 ?        SLsl 14:02   0:00 @dmon
--offroot md127
root      3326  0.0  0.2  14920 10820 ?        SLsl 15:16   0:00 mdmon
--takeover md127
root      3343  0.0  0.2  14920 10820 ?        SLsl 15:17   0:00 mdmon
--takeover md127

Is this expected ?

Thanks.
-- 
Francis
