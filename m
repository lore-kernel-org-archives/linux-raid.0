From: Nix <nix@esperi.org.uk>
Subject: Re: Recommended filesystem for RAID 6
Date: Wed, 12 Aug 2020 15:16:37 +0100
Message-ID: <87sgcsar0a.fsf@esperi.org.uk>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
        <20200811212305.02fec65a@natsu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200811212305.02fec65a@natsu> (Roman Mamedov's message of "Tue,
        11 Aug 2020 21:23:05 +0500")
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: George Rapp <george.rapp@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11 Aug 2020, Roman Mamedov stated:
> For the FS considerations, the dealbreaker of XFS for me is its inability to
> be shrunk. The ivory tower people do not think that is important enough, but
> for me that limits the FS applicability severely. Also it loved truncating
> currently-open files to zero bytes on power loss (dunno if that's been
> improved).

I've been using XFS for more than ten years now and have never seen this
allegedly frequent behaviour at all. It certainly seems to be less
common than, say, fs damage due to the (unjournalled) RAID write hole.

I suspect you're talking about this:
<https://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_see_binary_NULLS_in_some_files_after_recovery_when_I_unplugged_the_power.3F>,
whicih was fixed in *2007*. So... ignore it, it's *long* dead. (Equally,
ignore complaints about xfs being really slow under heavy metadata
updates: this was true before delayed logging was implemented, but
delaylog has been non-experimental since 2.6.39 (2011) and the
non-delaylog option was removed in 2015. xfs is often now faster than
ext4 at metadata operations, and is generally on par with it.

Shrinking xfs is relatively irrelevant these days: if you want to be
able to shrink, use thin provisioning and run fstrim periodically. The
space used by the fs will then shrink whenever fstrim is run, with no
need to mess about with filesystem resizing.
