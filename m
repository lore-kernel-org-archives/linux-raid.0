From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: write-refresh md array (feature request)
Date: Wed, 11 Sep 2013 17:15:50 -0300
Message-ID: <20130911201550.GA15507@khazad-dum.debian.net>
References: <20130910181905.GC21530@khazad-dum.debian.net>
 <CAGqmV7ph6JF1cVQwBt-FrzToThMC+gbfPMj3V5EFqbtoOFuFHQ@mail.gmail.com>
 <20130911123747.GB1736@khazad-dum.debian.net>
 <CAA9_cmfFSM8v-xEBHdVXuGXcRUcWa6qcHrdwjUqECSsKnY2t5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmfFSM8v-xEBHdVXuGXcRUcWa6qcHrdwjUqECSsKnY2t5Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 11 Sep 2013, Dan Williams wrote:
> On Wed, Sep 11, 2013 at 5:37 AM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Wed, 11 Sep 2013, CoolCold wrote:
> >> You can achieve this with a bit inderect way - there are sync_min and
> >> sync_max params which can be used to operate on certain borders of array,
> >> more info
> >> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/md.txt?id=refs/tags/v3.11#n579.
> >
> > Doesn't do anything close to what I requested.  Neither check nor repair
> > will re-write sectors that appear to be good (and are actually returning the
> > correct data after ECC correction by the component device, but will
> > eventually fail if not rewritten to soon).
> 
> Sounds like a modification of the "replace" code to allow replacing
> the with self-same drive. Something like "want_refresh" would mark the

That would do it, if the system considers that the component device is still
valid while it is being replaced in-place with itself :)

> drive as a soft replacement to mark that slot to be re-written.  But
> if the drive is expected to be "weak" you could just rotate in a spare
> drive without degrading the array with the existing code.

Well, that requires a spare device, which is often not the case in small
setups (which are the ones more likely to be using md raid with SATA,
instead of SAS).

Although I really don't know if SAS nearline devices are any better than the
current crop of untrustworthy crap that passes for SATA HDDs.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
