From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 4/4] imsm: monitor: do not finish recovery, when raid goes
 to read-only
Date: Thu, 5 Apr 2012 10:37:15 -0700
Message-ID: <CABE8wwsGehaT1xpYWSwX8yogqNEYw3GtSjROwohnH_ev17iBtg@mail.gmail.com>
References: <20120405152553.19851.48052.stgit@linux.site>
	<20120405153126.19851.45474.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405153126.19851.45474.stgit@linux.site>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, Apr 5, 2012 at 8:31 AM, Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> If kernel forces raid to be read-only (eg. during reboot, and root
> partition lies on array) monitor should not finish recovery and leave
> metadata untouched.

I'm not sure I understand the point of this one, can you clarify?
Even though the rootfs is readonly at initial boot it may still
require the root block device to be readwrite.  For example xfs needs
to do journal playback even when mounting ro.  So if the monitor is
running at all it means that the array was started read-write (or at
least read-auto) and should be fine to complete recovery.

--
Dan
