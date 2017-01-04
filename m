From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Don't assume VMD sysfs path ends with a disk entry
Date: Wed, 04 Jan 2017 08:27:36 -0500
Message-ID: <wrfj1swjvttj.fsf@redhat.com>
References: <1483526724-29456-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1483526724-29456-1-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Wed, 4 Jan 2017 11:45:24 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
>
> From: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
> Date: Wed, 4 Jan 2017 11:31:23 +0100
>
> When VMD is enabled but no drive is attached to the PCIe port, mdadm
> crashes trying to parse the path. Skip entry if valid path has not been
> returned. Do it early to avoid unnecessary memory allocation.
>
> Signed-off-by: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  platform-intel.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)

Applied!

I had to fixup the commit message since your message had a mail header
from Alaexy as well.

Thanks,
Jes
