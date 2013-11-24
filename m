From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Triple parity and beyond
Date: Sun, 24 Nov 2013 14:31:42 -0800
Message-ID: <CAK2H+ec12DV6=XXrQMCRoa+kwZs+wafwwvuNweCwaEo5gSReJQ@mail.gmail.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<20131123181208.5103bee4@notabene.brown>
	<52917AA8.1040300@hardwarefreak.com>
	<201311241619.08668.russell@coker.com.au>
	<52927343.9000203@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52927343.9000203@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: russell@coker.com.au, Linux RAID Mailing List <linux-raid@vger.kernel.org>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Nov 24, 2013 at 1:44 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
<SNIP>
>> Are you suggesting that it would be a common case that people just write data
>> to an array and never read it or do an array scrub?  I hope that it will
>> become standard practice to have a cron job scrubbing all filesystems.
>
> Given the frequency of RAID5 double drive failure "save me!" help
> requests we see on a very regular basis here, it seems pretty clear this
> is exactly what many users do.

Thank you for reminding me to set this up. Sunday afternoons at 2:30
is now my scrub time.

Cheers,
Mark
