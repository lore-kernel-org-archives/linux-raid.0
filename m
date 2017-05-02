From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] change back 0644 permission for Grow.c
Date: Tue, 2 May 2017 09:45:05 -0400
Message-ID: <832ae4d1-4127-6b48-06b8-6b709a191b38@gmail.com>
References: <1493717233-32524-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1493717233-32524-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/02/2017 05:27 AM, Zhilong Liu wrote:
> Fixes commit:
> 26714713cd2b ("mdadm: Change timestamps to unsigned data type.")
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Grow.c | 0
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  mode change 100755 => 100644 Grow.c
>
> diff --git a/Grow.c b/Grow.c
> old mode 100755
> new mode 100644
>

Hi Zhilong,

Not quite sure what you expect me to do with this one......

Maybe including the patch would help :)

Cheers,
Jes

