From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [MDADM PATCH 1/1] Add detail information when can not connect monitor
Date: Mon, 09 Jan 2017 07:50:35 -0500
Message-ID: <wrfjbmvgfld0.fsf@redhat.com>
References: <1483844394-7647-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1483844394-7647-1-git-send-email-xni@redhat.com> (Xiao Ni's
        message of "Sun, 8 Jan 2017 10:59:54 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, osamarin68@gmail.com
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> If it can't connect monitor, now the error message is just
> Error waiting for xxx to be clean. Add detail error message
> in connect_monitor.
>
> Suggested-by: Oleg Samarin <osamarin68@gmail.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  msg.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied!

Thanks,
Jes
