From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Disappointing RAID10 Performance
Date: Sun, 18 Oct 2009 05:06:46 -0700 (PDT)
Message-ID: <562792.28327.qm@web38806.mail.mud.yahoo.com>
References: <7bc80d500910161420p3e16e20bj7ee69ee1d3ac3a9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7bc80d500910161420p3e16e20bj7ee69ee1d3ac3a9f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Fri, 10/16/09, Christopher Chen <muffaleta@gmail.com> wrote:
> It's plausible that md's read balancing would increase the
> read speed,
> but it appears that this is not the case. Are you using
> LVM? And the
> readahead for the block devices are set appropriately?
> Distro? Version
> of mdadm?

No LVM, and readahead on sd? drives set for best performance.  Debian Testing with mdadm 3.0-2.


      
