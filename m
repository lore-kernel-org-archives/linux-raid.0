From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID without superblock
Date: Mon, 20 Apr 2009 20:10:45 +0200
Message-ID: <20090420181045.GA4236@lazy.lzy>
References: <20090419114743.GA29195@lazy.lzy> <e96b335a0ba8595e2921d164f9b15ff7.squirrel@neil.brown.name> <20090419210200.GA6942@lazy.lzy> <1240178252.31728.12.camel@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1240178252.31728.12.camel@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

first of all thanks a lot for all the suggestions,
it is really nice to have this support!

While reading the answers, I realized that I did
not make the "requirements" really clear. My bad.

The "primary" disk is an external one, which 90%
of the time is connected to the same Linux PC.
But, it could happen it is removed and connected
somewhere else, where no "md" is available.

My idea was, in order to have some protection, to
use it in RAID-1 "superblockless" configuration
on the "default" PC, and use it as a normal disk
whenever (or wherever) necessary.
Of course, the bitmap resync will not work, when
updating the disk directly, without "md" layer.

On the other hand, if the full-resync is always
done from this disk to the local mirror, there
would be no problem, except time.

The reason to do this kind of backup is that this
disk is encrypted, so a "block device copy" will
keep the data encrypted, while a backup of the
mounted disk will not. Unless done to another
encrypted disk/partition, of course.

Clearly, any suggestion is still really appreciated!

Thanks again,

bye,

-- 

piergiorgio
