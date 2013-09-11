From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: write-refresh md array (feature request)
Date: Wed, 11 Sep 2013 09:37:47 -0300
Message-ID: <20130911123747.GB1736@khazad-dum.debian.net>
References: <20130910181905.GC21530@khazad-dum.debian.net>
 <CAGqmV7ph6JF1cVQwBt-FrzToThMC+gbfPMj3V5EFqbtoOFuFHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGqmV7ph6JF1cVQwBt-FrzToThMC+gbfPMj3V5EFqbtoOFuFHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 11 Sep 2013, CoolCold wrote:
> You can achieve this with a bit inderect way - there are sync_min and
> sync_max params which can be used to operate on certain borders of array,
> more info
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/md.txt?id=refs/tags/v3.11#n579.

Doesn't do anything close to what I requested.  Neither check nor repair
will re-write sectors that appear to be good (and are actually returning the
correct data after ECC correction by the component device, but will
eventually fail if not rewritten to soon).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
