From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: patches for mdadm 1.8.0 (auto=dev and stacking of devices)
Date: Sun, 23 Jan 2005 17:13:56 +0100
Message-ID: <43vcc2-u85.ln1@news.it.uc3m.es>
References: <20050123151305.GB15317@percy.comedia.it> <20050123152819.GE24350@marowsky-bree.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2005-01-23T16:13:05, Luca Berra <bluca@comedia.it> wrote:
> 
> > the first one adds an auto=dev parameter
> > rationale: udev does not create /dev/md* device files, so we need a way
> > to create them when assembling the md device.
> 
> Am I missing something but shouldn't this be fixed by having udev +
> hotplug create the /dev entry correctly?

:-)

I mussht find out shabout udev b'fre it goesh away.

I didn't realize that hotplug could get involved. Will block.agent do
that kind of trick if I ask it to? Must experiment. 

Nice idea.

Peer

