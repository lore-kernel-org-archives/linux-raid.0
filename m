From: "NeilBrown" <neilb@suse.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Sat, 9 May 2009 08:16:27 +1000 (EST)
Message-ID: <21cdc7a16fbdd42979d52331db97c737.squirrel@neil.brown.name>
References: <20090503013342770.VMBT19475@cdptpa-omta01.mail.rr.com>
    <e13f0e541934a0966f213f6da13d83da.squirrel@neil.brown.name>
    <1241406283.17240.26.camel@ezra>
    <87fxff462s.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fxff462s.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, May 9, 2009 7:50 am, Goswin von Brederlow wrote:

>>> So I still plan to offer a "--reserve-space=2M" option for mdadm to
>>> allow the first 2M of each device to not used for raid data.  Whether
>>> any particular usage of this option is viable or not, is a different
>>> question altogether.
>
> How exactly would that layout be then?
>
> Block  0   bootblock
> Block  1   raid metadata
> Block  x   2M reserved space
> Block x+2M start of raid data
>
> Like this?

When using 1.2 metadata, yes, possible with bitmap
inserted  between the reserved space and the start of raid data.

When using 1.0, it would be

  Block 0..N-1   boot block and second stage
  Block N..near-the-end raid data
  Block x..y     bitmap
  block z        superblock

NeilBrown

