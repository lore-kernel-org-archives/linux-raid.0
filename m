From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: write-refresh md array (feature request)
Date: Wed, 11 Sep 2013 09:32:23 -0300
Message-ID: <20130911123222.GA1736@khazad-dum.debian.net>
References: <20130910181905.GC21530@khazad-dum.debian.net>
 <CAA9_cmc+hJ9MrGyZDRXbUPNPcpgwm1RNvWQ4yX65zqKZy4puuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmc+hJ9MrGyZDRXbUPNPcpgwm1RNvWQ4yX65zqKZy4puuQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 10 Sep 2013, Dan Williams wrote:
> On Tue, Sep 10, 2013 at 11:19 AM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > (please CC me on replies).
> > I've been in several situations where it would have been helpful to be able
> > to refresh weak sectors by rewriting the whole md raid component device,
> > without the need to increase array failure risk through a fail+remove+add
> > cycle for the component device.
> >
> > How difficult would it be to implement a "refresh" as a Linux md driver
> > sync_action, pigging back on "check" ?
> >
> > Are there any drawbacks to write-refreshing component devices?
> >
> 
> Why is "check" insufficient?  If it trips over any bad sectors it will
> re-write them.

The idea is to rewrite the sector _before_ it goes bad.

Consumer SATA HDDs nowadays not only apparently fail to properly remap
sectors because they don't track anymore that some sectors in that subtrack
were reported uncorrect a number of times (and thus are "weak").  They also
appear to not write-refresh sectors that required ECC correction, except
maybe during an offline SMART test routine.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
