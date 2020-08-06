From: Song Liu <song@kernel.org>
Subject: Re: [PATCH] md: get sysfs entry after redundancy attr group create
Date: Wed, 5 Aug 2020 17:05:41 -0700
Message-ID: <CAPhsuW6m3B509L58Adrzw6k+34SMYbXKrk8vxARhcnNJfz8k1Q@mail.gmail.com>
References: <20200805002718.50839-1-junxiao.bi@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200805002718.50839-1-junxiao.bi@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 4, 2020 at 5:29 PM Junxiao Bi <junxiao.bi@oracle.com> wrote:
>
> "sync_completed" and "degraded" belongs to redundancy attr group,
> it was not exist yet when md device was created.
>
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Fixes: e1a86dbbbd6a ("md: fix deadlock causing by sysfs_notify")
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Applied to md-next. Thanks!
