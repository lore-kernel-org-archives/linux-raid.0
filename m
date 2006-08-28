From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Resize on dirty array?
Date: Mon, 28 Aug 2006 08:36:01 +0200
Message-ID: <ecu2sh$3nm$1@sea.gmane.org>
References: <44D7DC93.2070905@net1plus.com> <17623.57067.835826.446152@cse.unsw.edu.au> <44D8E535.9080208@net1plus.com> <17625.24594.568139.430440@cse.unsw.edu.au> <44D9C6F5.7070501@net1plus.com> <5b170a7d0608120022n39742f2cl8f8017f6cc328f5e@mail.gmail.com> <17650.30521.355859.724575@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:
> I would be a lot happier about it if the block layer told me whether
> the fail was a Media error or some other sort of error.

This wouldn't help you either. I've seen drives (mainly Samsung) that
locked up the whole IDE bus after some simple (subsequent) sector-read-
errors.
And with strange IDE drivers (like PDC202XX_NEW) this could also
escalate to whole-machine freezes - I've also seen this and had to play
hardly with device-mapper's dm-error target to work around this :)

So IMHO at least the default behaviour should stay as it currently is:
if a drive fails, do never ever touch it again. Perhaps, you could make
such a "FAILING" feature somehow configurable (perhaps even on a
per-mirror base) in order to allow users to enable it for drives they
*do* know they don't show up such a bad behaviour.


regards
   Mario
-- 
Independence Day: Fortunately, the alien computer operating system works just
fine with the laptop. This proves an important point which Apple enthusiasts
have known for years. While the evil empire of Microsoft may dominate the
computers of Earth people, more advanced life forms clearly prefer Macs.

