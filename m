From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 15:04:12 +0100
Message-ID: <20080129140412.GC30679@rap.rap.dk>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479F07E1.7060408@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2008 at 05:02:57AM -0600, Moshe Yudkowsky wrote:
> Neil, thanks for writing. A couple of follow-up questions to you and the 
> group:
> 
> If the answers above don't lead to a resolution, I can create two RAID1 
> pairs and join them using LVM. I would take a hit by using LVM to tie 
> the pairs intead of RAID0, I suppose, but I would avoid the performance 
> hit of multiple md drives on a single physical drive, and I could even 
> run a hot spare through a sparing group. Any comments on the performance 
> hit -- is raid1L a really bad idea for some reason?

You can of cause construct a traditional raid-1+0 in Linux as you describe here,
but this is different from linux raid10 (with its different layout
possibilities). And constructing two grub/lilos on two disks for a raid1
on /boot seems to be the right way for a reasonably secured system.

best regards
keld
