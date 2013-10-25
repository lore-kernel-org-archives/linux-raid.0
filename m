From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Help raid10 recovery from 2 disks removed
Date: Fri, 25 Oct 2013 10:24:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310251023070.1838@uplift.swm.pp.se>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net> <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net> <alpine.DEB.2.02.1310241441280.1838@uplift.swm.pp.se> <2614300.keHkAfZ48K@eseries.newtech.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2614300.keHkAfZ48K@eseries.newtech.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Dag Nygren <dag@newtech.fi>
Cc: yuji_touya@yokogawa-digital.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 25 Oct 2013, Dag Nygren wrote:

> And I don't think he needs to loose any data, nor use ddrescue here.

He has no redundancy drive for his data, so unfortunately I believe he 
does.

Your advice makes a lot of sense and all people should look into this (if 
you feel like it, document it on the wiki, but in his case his parity 
drive was kicked out long ago.

> After taht run "echo "repair" >/sys/block/md0/md/sync_action"

Works great if there is proper redundancy.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
