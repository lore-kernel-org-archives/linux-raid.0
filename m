From: "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: Re: [PATCH v2] mdadm/Detail: show correct state for cluster-md array
Date: Wed, 22 Jul 2020 15:20:07 +0800
Message-ID: <7697b7eb-76f9-8102-a490-1684e5f18acf@suse.com>
References: <1595401905-3459-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595401905-3459-1-git-send-email-heming.zhao@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, jes@trained-monkey.org
List-Id: linux-raid.ids

During I was creating patch, I found the ExamineBitmap() has memory leak issue.
I am not sure whether the leak issue should be fixed.
(Because when mdadm cmd finish, all leaked memory will be released).
The IsBitmapDirty() used some of ExamineBitmap() code, and I only fixed leaked issue in IsBitmapDirty().

Thanks,
heming

On 7/22/20 3:11 PM, Zhao Heming wrote:
> After kernel md module commit 480523feae581, in md-cluster env,
> mddev->in_sync always zero, it will make array.state never set
> up MD_SB_CLEAN. it causes "mdadm -D /dev/mdX" show state 'active'
> all the time.
> 
> bitmap.c: add a new API IsBitmapDirty() to support inquiry bitmap
> dirty or clean.
> 
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
> v2:
> - Detail.c: change to read only one device.
> - bitmap.c: modify IsBitmapDirty() to check all bitmap on the selected device.
> 
