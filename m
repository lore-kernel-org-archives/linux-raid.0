From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: Array Power Management
Date: Thu, 10 Sep 2009 11:51:56 -0500
Message-ID: <20090910165156.GA30820@sewage>
References: <292245.77763.qm@web55804.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <292245.77763.qm@web55804.mail.re3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Sep 06, 2009 at 08:48:03PM -0700, jahammonds prost wrote:
> I can do this on single drives using hdparm -S to set the spindown
> timeout, and the disks will spin up on activity as needed. Is
> there something similar I can do with an md array? I can see
> there's a /sys/block/md0/power/wakeup file, but I can't seem to
> find any documentation on it. I have thought about doing an hdparm
> -S on the array disks, but I suspect that would be A Bad Thing
> (tm).

On the same note, does anyone have any thoughts on the wear-and-tear
caused by frequent spinup/spindown cycles?

My fileserver has the Western Digital RE2 "enterprise" grade drives.
I remember reading (years ago) that, in general, "enterprise" grade
drives were designed to be always running (think 24/7 server), and
rarely spun down.  As such, they did not tolerate a "consumer
desktop" usage pattern very well, and trying to save power in this
way would actually cause them to fail prematurely.

Is/was such a thing true?  Is it worth worrying about?

Thanks,
Matt

