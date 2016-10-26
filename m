From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] imsm: load migration record from right disk
Date: Wed, 26 Oct 2016 12:01:04 -0400
Message-ID: <wrfjoa27m75r.fsf@redhat.com>
References: <1477303217-7968-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477303217-7968-1-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Mon, 24 Oct 2016 12:00:17 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> Migration record is only stored on disks in first and second metadata
> slot. The function to load the record incorrectly passes disk slot as
> disk index. If rebuilt has taken place for a container, disk slot
> doesn't match disk index so it causes migration record to be read from a
> disk it has not been written to. As a result reshape operation fails.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  super-intel.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)

Applied!

Thanks,
Jes
