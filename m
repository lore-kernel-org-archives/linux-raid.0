From: Tomas M <tomas@slax.org>
Subject: Re: How to prefer some devices over others in raid
Date: Wed, 1 Jan 2014 19:00:31 +0100
Message-ID: <CAL1oBhovXZhnKMqzoYt=7N5ZHeyX76LK+1LNYMRmcQGGqs7W3w@mail.gmail.com>
References: <CAL1oBhr+V0NQ1zG4LVP8qFT3_wsMHnqhUkZafVibtk0oCDGg5Q@mail.gmail.com>
 <52C2E00B.90406@hardwarefreak.com> <CAL1oBhrVUTK5ayU=sgmVgP0Xu5eh1nGcfRjQSYALXXJMVE03+w@mail.gmail.com>
 <52C44708.3030307@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C44708.3030307@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Your initial post suggested you knew which drive was flaky.  Now you
> indicate you don't know which, if any, is flaky.  This suggests you have
> no idea why your array is slow.

Well, I always have an indication which drive is flaky, based on dmesg
output (e.g. hard resetting ATA3 link, etc). However, sometimes it
reports that more than one drive has problems, and I can't be 100%
sure which of the flaky drives is the "more flaky" one :) and it is
too late to replace any of them, since there is high chance that the
other one dies as well during resync (which happened to me few times
already). From my point of view it is better for me to keep the array
in sync as long as I can, and copy the data somewhere as fast as I
can.

NeilBrown's suggestion looks like very simple logic needed to
implement, however the amount of nested ANDs and ORs in fetch_block()
in raid5.c is too huge to my understanding :-) so I'm giving up :)

Tomas M
