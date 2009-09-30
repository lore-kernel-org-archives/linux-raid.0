From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 14214] New: BUG at
 drivers/scsi/scsi_lib.c:1108!
Date: Wed, 30 Sep 2009 21:19:24 +0000
Message-ID: <1254345564.3925.533.camel@mulgrave.site>
References: <bug-14214-10286@http.bugzilla.kernel.org/>
	 <20090930125607.752808d6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090930125607.752808d6.akpm@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>, bugzilla-daemon@bugzilla.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2009-09-30 at 12:56 -0700, Andrew Morton wrote:
> On Wed, 23 Sep 2009 11:13:26 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=14214
> 
> Post-2.6.31 regression.  This, in scsi_setup_fs_cmnd():
> 
>         /*
>          * Filesystem requests must transfer data.
>          */
>         BUG_ON(!req->nr_phys_segments);

Well, the BUG_ON is correct: there can't be a FS type command with no
data.

This can't be a SCSI issue because the problem was caused before SCSI
was entered.  Looking at the backtrace (all functions listed as
unreliable, sigh) this is either a deadline scheduler problem (less
likely) or an md_raid one (more likely).

Let's start with what was the mdraid configuration and condition of the
filesystem being mounted? I've added linux-raid to the cc list so they
can chime in for more details.

James


