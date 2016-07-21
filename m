From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v3] Remove: container should wait for an array to release a drive
Date: Thu, 21 Jul 2016 11:26:12 -0400
Message-ID: <wrfj4m7jm2qz.fsf@redhat.com>
References: <1469087982-2102-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1469087982-2102-1-git-send-email-tomasz.majchrzak@intel.com>
	(Tomasz Majchrzak's message of "Thu, 21 Jul 2016 09:59:42 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> A 'faulty' drive is being removed from a container after it has been
> released by an array, however there is a race there. The drive is
> released asynchronously by a monitor but sometimes it doesn't happen
> before container checks it. It results in a container refusing to remove
> a drive as it still seems to be a part of some array.
>
> It seems 'ping_monitor' could be a solution here to assure monitor has
> had a chance to process the events, however it doesn't resolve the
> problem - sometimes an array has to request a release of the drive few
> times (as the array is busy) and single 'ping_monitor' call is not
> sufficient. As there is no way to query monitor progress, it forces us
> to retry a check several times before an error is returned.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  Manage.c | 41 ++++++++++++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 13 deletions(-)

Looks good - applied!

Thanks,
Jes
