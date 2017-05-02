From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH 2/2] util: unify stat operations into function
Date: Tue, 2 May 2017 09:50:57 -0400
Message-ID: <d46e9f1a-c3fe-3eb7-b163-7f96780b5575@gmail.com>
References: <20170502032646.20220-1-zlliu@suse.com>
 <20170502032646.20220-3-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170502032646.20220-3-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/01/2017 11:26 PM, Zhilong Liu wrote:
> declare new function to integrate repeated stat operations,
> the devname is necessary and the *rdev is optional argument,
> parse the pointer of dev_t *rdev, if valid, assigned device
> number to rdev, if NULL, ignores.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Assemble.c    |  7 ++-----
>  Build.c       | 25 ++++---------------------
>  Incremental.c | 21 ++++-----------------
>  Manage.c      | 11 +----------
>  Monitor.c     | 16 ++++------------
>  mdadm.h       |  1 +
>  super-ddf.c   | 10 ++++------
>  super-intel.c | 10 ++++------
>  util.c        | 17 +++++++++++++++++
>  9 files changed, 41 insertions(+), 77 deletions(-)

Same comment as for the fstat() version applies here.

Cheers,
Jes


