From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 0/3] mdadm patches for some trivial fixes
Date: Mon, 2 Oct 2017 16:00:44 -0400
Message-ID: <e14c25f6-4b85-eda8-1a5e-0a50fe5f943c@gmail.com>
References: <1504604498-26048-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1504604498-26048-1-git-send-email-zlliu@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/05/2017 05:41 AM, Zhilong Liu wrote:
> Hi, Jes;
>    mdadm is not willing to set component size as '0' actually,
> does the first patch make sense for this scenario?
> 
> Thanks,
> Zhilong
> 
> Zhilong Liu (3):
>    mdadm/grow: Component size must be larger than chunk size
>    mdadm/manpage: disable bitmap_resize for external file bitmap
>    mdadm: fixes some trivial typos in comments
> 
>   Grow.c     | 6 ++++++
>   ReadMe.c   | 2 +-
>   mdadm.8.in | 5 +++++
>   super1.c   | 8 ++++----
>   4 files changed, 16 insertions(+), 5 deletions(-)
> 

Applied!

Thanks,
Jes

