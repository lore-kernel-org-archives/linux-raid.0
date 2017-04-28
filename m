From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Fri, 28 Apr 2017 13:39:25 +0200
Message-ID: <20170428113925.GB3793@metamorpher.de>
References: <20170425001614.GA3936@metamorpher.de>
 <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de>
 <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
 <20170425110807.GA5159@metamorpher.de>
 <5c3f7876-1b25-7020-5e7d-01776e7c9903@powerlamerz.org>
 <20170427231242.GA5138@metamorpher.de>
 <CAHKno4DBXT5n7wYosie_WHBhzXnHj0CFkdjv7_VAN2NVF-Ng4g@mail.gmail.com>
 <20170428095252.GA3793@metamorpher.de>
 <CAHKno4DWXfOw-ejU5zfh_A8WiG7haSafNTbJLM4Ue1oTCFksyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHKno4DWXfOw-ejU5zfh_A8WiG7haSafNTbJLM4Ue1oTCFksyw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 28, 2017 at 12:31:43PM +0200, Patrik Dahlström wrote:
> Can't I reduce my risks by doing it the other way around?

Not like this.

> dd if=/dev/md6 bs=1M count=X/1M of=/dev/md5

Writes into data you haven't read yet, so you end up reading data 
you just wrote and write that again... the result will be garbage.

ddrescue has a reverse mode but implementation details matter a lot. 
It might be tempting because your progress is just 10-20%ish but 
going forwards is a lot safer here.

If you must go backwards you should use mdadm's revert-reshape 
for which you need RAID metadata that properly represents the 
current mid-grow state of your RAID (the elegant approach).

You can produce such metadata by

truncate -s <drivesize> a b c d e f
losetup --find -show
mdadm --create 5disk
mdadm --grow 6disk
<fallocate punchhole in the background>
<adapt sync_speed_min/max in the background>
<watch progress until X>
mdadm --stop
mdadm --examine <verify correct offsets and reshape pos'n>

Tadaa.

Regards
Andreas Klauer
