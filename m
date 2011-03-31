From: hansbkk@gmail.com
Subject: Re: Network-based RAID6
Date: Thu, 31 Mar 2011 14:59:45 +0700
Message-ID: <BANLkTikRH77LFxn6BEYezOsHbk5B1KzzHw@mail.gmail.com>
References: <20110330131157.49fd2521@natsu>
	<AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>
	<20110330144944.3c87185c@natsu>
	<4D933188.30003@hardwarefreak.com>
	<20110330235052.3a803d35@natsu>
	<4D94097A.3030909@hardwarefreak.com>
	<20110331111613.06079a0a@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110331111613.06079a0a@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 31, 2011 at 12:16 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Wed, 30 Mar 2011 23:56:26 -0500
> I thought DRBD presents just a regular kernel-level block device in /dev, and
> seeing how one can create mdraid out of just any kind of block device,
> including those provided by AoE, iSCSI, LVM, dmcrypt or even 'loop', are you
> really sure this matters here?

The only advantage of RAID5/6 over mirroring is cost savings,
certainly not greater fault tolerance taking rebuilding times into
account - if you're planning to set up separate whole servers for each
component of your redundancy strategy, it seems odd to me you're
trying to saving a few bucks on hard drives.

DRBD is a well-regarded solution for this application, but it is
oriented toward mirroring whole filesystems (usually those of
mission-critical servers) that may themselves already be protected
locally with RAID. I would advise you follow their standard
recommendations at first, don't get too "creative" if you're actually
looking for fault-tolerance rather than just experimenting around.

All that said, if you're looking for a fun experiment and go ahead,
please do document your results and report back here!
