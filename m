From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Monitor: release /proc/mdstat fd when no arrays present
Date: Thu, 21 Jul 2016 11:37:41 -0400
Message-ID: <wrfjh9bjknne.fsf@redhat.com>
References: <1467702771-1375-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1467702771-1375-1-git-send-email-tomasz.majchrzak@intel.com>
	(Tomasz Majchrzak's message of "Tue, 5 Jul 2016 09:12:51 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> If md kernel module is reloaded, /proc/mdstat cannot be accessed ("cat:
> /proc/mdstat: No such file or directory"). The reason is mdadm monitor
> still holds a file descriptor to previous /proc/mdstat instance. It
> leads to really confusing outcome of the following operations - mdadm
> seems to run without errors, however some udev rules don't get executed
> and new array doesn't work.
>
> Add a check if lseek was successful as it fails if md kernel module has
> been unloaded - close a file descriptor then. The problem is mdadm
> monitor doesn't always do it before next operation takes place. To
> prevent it monitor always releases /proc/mdstat descriptor when there
> are no arrays to be monitored, just in case driver unload happens in a
> moment.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  Monitor.c | 2 ++
>  mdstat.c  | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)

Looks good, applied!

Thanks,
Jes
