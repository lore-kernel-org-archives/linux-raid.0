From: jes.sorensen@gmail.com
Subject: Re: [PATCH 1/2] Replace snprintf with strncpy at some places to avoid truncation
Date: Tue, 28 Mar 2017 13:55:05 -0400
Message-ID: <wrfjlgrpgubq.fsf@gmail.com>
References: <1489804425-4949-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489804425-4949-1-git-send-email-xni@redhat.com> (Xiao Ni's
        message of "Sat, 18 Mar 2017 10:33:44 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> In gcc7 there are some building errors like:
> directive output may be truncated writing up to 31 bytes into a region of size 24
> snprintf(str, MPB_SIG_LEN, %s, mpb->sig);
>
> It just need to copy one string to target. So use strncpy to replace it.
>
> For this line code: snprintf(str, MPB_SIG_LEN, %s, mpb->sig);
> Because mpb->sig has the content of version after magic, so
> it's better to use strncpy to replace snprintf too.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  super-intel.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Applied!

Thanks,
Jes
