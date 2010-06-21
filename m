From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: How to boost performance [SOLVED]
Date: Mon, 21 Jun 2010 02:21:38 +0200
Message-ID: <201006210221.39354.bernd.schubert@fastmail.fm>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com> <AANLkTinV3i0vpR9i4_VCbcrGEqxoLGfQY_SrgDftQwJ_@mail.gmail.com> <6048c257b28c2c1461166f5e1eea0346.squirrel@www.dcsnow.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6048c257b28c2c1461166f5e1eea0346.squirrel@www.dcsnow.com>
Sender: linux-raid-owner@vger.kernel.org
To: aragonx@dcsnow.com
Cc: Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday, June 21, 2010, aragonx@dcsnow.com wrote:
> Thank you all for your many suggestions.
> 
> After performing all the tweaks suggested, I was able to write a 5GB file
> from my workstation to my server at 100MB/sec!!!  Reads (from the server)
> are equally as fast and are mainly limited by my workstation now.  The
> server has dual bonded gigabit NICs so it can throw the data pretty fast.
> 
> Here is what I did:
> 
> echo 16384 > /sys/block/md0/md/stripe_cache_size
> Added to /etc/fstab for md0:   barrier=1,journal_checksum,stripe=5

Uh, be careful with journal_checksum. I have a nice Lustre bug, where journal 
checksums actually caused filesystem corruption. If you really want to use it, 
you should first ask on the ext4 list what it the state of that. CC me and I 
will jump in. 
I'm not sure if my issue already was fixed, but last time I looked at the 
code, the replay procedure in case of a failure was not optimal. 
Unfortunately, it has a low priority on my long Lustre bug list... (Lustre 
uses a patched ext3/ext4, so such issues just come through to Lustre).


Cheers,
Bernd
