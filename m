From: jes.sorensen@gmail.com
Subject: Re: [PATCH 2/3] mdadm: Add Wimplicit-fallthrough=0 in Makefile
Date: Fri, 17 Mar 2017 15:57:17 -0400
Message-ID: <wrfjd1dfk76q.fsf@gmail.com>
References: <1489751743-11397-1-git-send-email-xni@redhat.com>
        <1489751743-11397-3-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489751743-11397-3-git-send-email-xni@redhat.com> (Xiao Ni's
        message of "Fri, 17 Mar 2017 19:55:42 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> There are many errors like 'error: this statement may fall through'.
> But the logic is right. So add the flag Wimplicit-fallthrough=0
> to disable the error messages. The method I use is from
> https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
> #index-Wimplicit-fallthrough-375
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Makefile | 5 +++++
>  1 file changed, 5 insertions(+)

Applied!

Thanks,
Jes
