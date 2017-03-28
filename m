From: jes.sorensen@gmail.com
Subject: Re: [PATCH 2/2] mdadm: Forced type conversion to avoid truncation
Date: Tue, 28 Mar 2017 13:57:15 -0400
Message-ID: <wrfjh92dgu84.fsf@gmail.com>
References: <1489804425-4949-1-git-send-email-xni@redhat.com>
        <1489804425-4949-2-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489804425-4949-2-git-send-email-xni@redhat.com> (Xiao Ni's
        message of "Sat, 18 Mar 2017 10:33:45 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> Gcc reports it needs 19 bytes to right to disk->serial. Because the type of argument i
> is int. But the meaning of i is failed disk number. So it doesn't need to use 19 bytes.
> Just add a type conversion to avoid this building error
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  super-intel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

I reformatted the commit message to keep it within 80 characters/line,
but no change of content.

Cheers,
Jes
