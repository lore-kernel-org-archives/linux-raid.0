From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: paralellism of device use in md
Date: Thu, 19 Jan 2006 12:30:47 +0100
Message-ID: <dqnt97$kj$1@sea.gmane.org>
References: <20060117120927.GU7017@strugglers.net> <43CD8A73.90703@nsr500.net> <dqkrfm$9k9$1@sea.gmane.org> <dqktgu$fea$1@sea.gmane.org> <fd8d0180601180955j691f5d2bn@mail.gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Francois Barre <francois.barre@gmail.com> wrote:
> 2006/1/18, Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>:
>> Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE> wrote:
>> Perhaps using some big (virtual) chunk size could do the trick? What
> Stop me if I'm wrong, but this is called... huge readahead. Instead of
> reading 32k on drive0 then 32k on drive1, you read continuous 512k
> from drive0 (16*32k) and 512k from drive1, resulting in a 1M read.
> Maybe for a single 4k page...

Yes, this would be the consequence.
However, this would probably not be a big issue, since a) the current
default read-ahead for RAID1 is 1024 (in 512-byte sectors) anyways.
Furthermore, in the hardware-RAID sector b) at least the 3ware support
recommends huge read-aheads for speeding up their RAID1s, too...
afaik they recommend:
vm.{min,max}-readahead=512
blockdev --setra 6144 /dev/...
which is far more than 1M. I don't know why they do so but I could
imagine they also use some strategy similar to the one I suggested.


regards
   Mario
-- 
Ho ho ho! I am Santa Claus of Borg. Nice assimilation all together!

