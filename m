From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: maximum disk capacity?
Date: Sat, 14 Jun 2003 09:15:20 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0306140913100.363@ddx.a2000.nu>
References: <007201c330b9$c316f310$3001a8c0@melkor> <16104.22361.508001.916567@gargle.gargle.HOWL>
 <00db01c330ca$5ae72290$3001a8c0@melkor> <200306121814.32072.bernd-schubert@web.de>
 <009001c3313d$54027880$df01010a@moon> <Pine.LNX.4.53.0306130949210.30359@ddx.a2000.nu>
 <016501c331d0$48854d00$6b01a8c0@bmoon>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <016501c331d0$48854d00$6b01a8c0@bmoon>
To: bmoon <bo@anthologysolutions.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 13 Jun 2003, bmoon wrote:

> What is the reason that it can not cover more than 2TB?
32 bits raid5 code

> By the way you are able to use more than 2TB, ~2.3TB???
> Why?
check the archive from this mailinglist
i was able to format 2.3TB (15*180GB raid5)
but when i was writing to the 2TB+ i lost my filesystem
