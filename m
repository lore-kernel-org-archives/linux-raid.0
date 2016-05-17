From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Two disk RAID10 inactive on boot if partition is missing
Date: Tue, 17 May 2016 12:13:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1605171209470.28372@uplift.swm.pp.se>
References: <CAN4OnogXN45Z3UUJyFzGgACPXuQMm1Gfw18kY9bjATrt5tvNqg@mail.gmail.com> <alpine.DEB.2.02.1605171038490.28372@uplift.swm.pp.se> <CAN4OnoguQMvnuUr7mGYpTi7_SonZ42Z5TSigKaJ0ZfZuiup0Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAN4OnoguQMvnuUr7mGYpTi7_SonZ42Z5TSigKaJ0ZfZuiup0Og@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kay <syllopsium@syllopsium.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 17 May 2016, Peter Kay wrote:

> I'm not trying to boot from it, and I'm using Salix (Slackware), not a 
> debian based distribution. My boot partitions are not raided.

The setting would still be valid if your distribution defaults to not 
assembling and using degraded arrays on boot.

A dmesg output from when "it doesn't work" would probably yield an answer 
if this is why it's not being started properly.

> If I tell mdam to activate the raid I get no errors, and nothing 
> happens.

It would be interesting to see what mdadm command options you use here, 
and mdadm output from this with verbose output (-v) turned on, and what is 
written in dmesg when you do this.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
