From: dean gaudet <dean@arctic.org>
Subject: Re: Observations of a failing disk
Date: Mon, 27 Nov 2006 16:29:15 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611271623270.8068@twinlark.arctic.org>
References: <456B65E1.20204@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <456B65E1.20204@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 28 Nov 2006, Richard Scobie wrote:

> Anyway, my biggest concern is why
> 
> echo repair > /sys/block/md5/md/sync_action
> 
> appeared to have no effect at all, when I understand that it should re-write
> unreadable sectors?

i've had the same thing happen on a seagate 7200.8 pata 400GB... and went 
through the same sequence of operations you described, and the dd fixed 
it.

one theory was that i lucked out and the pending sectors in the unused 
disk near the md superblock... but since that's in general only about 90KB 
of disk i was kind of skeptical.  it's certainly possible, but seems 
unlikely.

another theory is that a pending sector doesn't always result in a read 
error -- i.e. depending on temperature?  but the question is, why wouldn't 
the disk try rewriting it if it does get a successful read.

i wish hard drives were a little less voodoo.

-dean
