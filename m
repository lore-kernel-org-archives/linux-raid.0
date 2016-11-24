From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH 1/4 v2] mdadm: bad block support for external metadata -
 initialization
Date: Thu, 24 Nov 2016 15:01:03 +0100
Message-ID: <20161124140103.GA8047@proton.igk.intel.com>
References: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 27, 2016 at 10:53:42AM +0200, Tomasz Majchrzak wrote:
> If metadata handler provides support for bad blocks, tell md by writing
> 'external_bbl' to rdev state file (both on create and assemble),
> followed by a list of known bad blocks written via sysfs 'bad_blocks'
> file.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  mdadm.h | 13 +++++++++++++
>  sysfs.c | 29 ++++++++++++++++++++++++++++-
>  2 files changed, 41 insertions(+), 1 deletion(-)

Hi Jes,

Do you have any comments for this patch set? It is a generic code for bad
block support for external metadata. It comes ahead of my other patch set
which provides IMSM implementation of new functionality.

Regards,

Tomek
