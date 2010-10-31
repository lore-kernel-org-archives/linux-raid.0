From: Neil Brown <neilb@suse.de>
Subject: Re: argh!
Date: Sun, 31 Oct 2010 17:44:40 -0400
Message-ID: <20101031174440.586709a7@notabene>
References: <AANLkTi=RS0-F-M29uaYi9wJ7wVzM63PVyJxDPt2WDhn_@mail.gmail.com>
	<C4.61.07087.9F0BCCC4@cdptpa-omtalb.mail.rr.com>
	<AANLkTimL=Z5gh+cbadd5+k66AoNZ8xc9upMbfE_Yqxac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimL=Z5gh+cbadd5+k66AoNZ8xc9upMbfE_Yqxac@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: jonathan.hardcastle@gmail.com, Leslie Rhorer <lrhorer@satx.rr.com>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 31 Oct 2010 21:18:52 +0000
Jon Hardcastle <jonathan.hardcastle@gmail.com> wrote:

> Hi,
> 
> Thanks for your help. I use 0.90 as that is what there was when the
> machine was build ~3yrs ago.. the array has been grown and resized
> since then.
> 
> Does anyone have a feature list for the superblocks? Why upgrade.....?

The "md" man page mentions a couple of differences:
  - v1.x can handle more than 28 devices in an array
  - v1.x can easily be moved between hosts with different endian-ness
  - v1.x can put the metadata at the front of the array

I should probably add the other differences.

  - with 0.90 there can be confusion about whether a superblock applies
    to the whole device or to just the last partition (if it start on a
    64K boundary).  1.x doesn't have that problem
  - With 1.x a device recovery can be checkpointed and restarted.
  - with 0.90, the maximum component for RAID1 or higher is 2TB (or maybe
    4TB, not sure).  With 1.x you can go much higher.


Those are the only ones I can think of at the moment.

It is rarely worth the effort to upgrade, but usually best to choose 1.2
for new arrays that you don't want to boot off.  If you want to boot of the
array, then whatever works with your boot-loader is the best choice.

NeilBrown

