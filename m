From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH] sysfs: include faulty drive in disk count
Date: Mon, 13 Nov 2017 09:09:19 +0100
Message-ID: <20171113080919.GA8293@proton.igk.intel.com>
References: <1510069796-17515-1-git-send-email-mariusz.tkaczyk@intel.com>
 <f8739ccc-3ca5-ed7a-4b3b-30e867a4f5de@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f8739ccc-3ca5-ed7a-4b3b-30e867a4f5de@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jsorensen@fb.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 09, 2017 at 03:46:08PM -0500, Jes Sorensen wrote:
> On 11/07/2017 10:49 AM, Mariusz Tkaczyk wrote:
> > When the disk fails, it goes into faulty state first and it is removed
> > from the array in a while. It gives mdadm monitor a chance to see the disk
> > has failed and notify an event (e.g. FailSpare). It doesn't work when 
> > sysfs is used to get a number of disks in the array as it skips faulty
> > disk. ioctl implementation doesn't differentiate between active and
> > faulty disk. Do the same for sysfs then. It should not matter that number
> > of disks reported is greater than list of disk structures returned by the
> > call because the same approach already takes place for offline disks.
> > 
> > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> > ---
> >  sysfs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Applied!
> 
> Thanks,
> Jes

Hi Jes,

Have you applied this patch? I don't see it on the repository. I see you
applied "imsm: More precise message when spanned raid is created" but you
haven't confirmed it by email.

Tomek
