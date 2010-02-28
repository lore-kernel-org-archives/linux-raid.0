From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Device role question
Date: Sun, 28 Feb 2010 11:38:24 +0100
Message-ID: <20100228103824.GB2296@lazy.lzy>
References: <20100226142331.GA2328@lazy.lzy>
 <4877c76c1002262156k6675877am79a7da9b63446dc7@mail.gmail.com>
 <20100227080845.GA2287@lazy.lzy>
 <4877c76c1002270055o2ebc038ag52e0b9a8f5b407d@mail.gmail.com>
 <20100227091027.GA3510@lazy.lzy>
 <4877c76c1002271934m3db22c7ahc93d3d4129df7d22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4877c76c1002271934m3db22c7ahc93d3d4129df7d22@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> What's confusing is that /proc/mdadm lists it as an active member
> (synced to data) but that the device does not match.  Maybe you can
> stop/restart the array?

thank for the support.
I tried to stop/start, incremental assembly (in different
order), fail/remove/add of both components (once at time,
of course), but this information seems to be stable.

The only thing I did not try was to fail/remove one HDD,
zero the superblock, add it again.

Anyway, it seems Neil explained this is a bug of mdadm,
so I hope this will be fixed in the next Fedora upgrade.

Thanks again,

bye,

-- 

piergiorgio
