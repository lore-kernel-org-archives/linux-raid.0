From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH] raid1: use an int as the return value of raise_barrier()
Date: Mon, 22 Jul 2019 14:46:04 -0700
Message-ID: <CAPhsuW5S0h66GxHeypS=3aGO=FAJ_J7TxoUatffXhOSiBzWCXg@mail.gmail.com>
References: <20190702143548.133020-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190702143548.133020-1-houtao1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hou Tao <houtao1@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 2, 2019 at 7:30 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Using a sector_t as the return value is misleading, because
> raise_barrier() only return 0 or -EINTR.
>
> Also add comments for the return values of raise_barrier().
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Applied. Thanks for the patch.

Song
