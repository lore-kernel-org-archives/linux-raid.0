From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND 1/2] fcntl: fix typo in RWH_WRITE_LIFE_NOT_SET r/w
 hint
Date: Fri, 26 Oct 2018 08:44:35 -0600
Message-ID: <cdbbf807-4df6-58c9-7d9c-2aeb1727c157@kernel.dk>
References: <8acaf8d7-17c9-e8ec-c60a-18a011b4c34f@kernel.dk>
 <cover.1540504380.git.evgsyr@gmail.com>
 <d3f2c6b14ebf020a07dff5e79410ac1c1fef6023.1540504380.git.evgsyr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d3f2c6b14ebf020a07dff5e79410ac1c1fef6023.1540504380.git.evgsyr@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Syromiatnikov <esyr@redhat.com>, linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 10/25/18 3:54 PM, Eugene Syromiatnikov wrote:
> According to commit message in the original commit v4.13-rc1~212^2~51,
> as well as userspace library[1] and man page update[2], R/W hint constants
> are intended to have RWH_* prefix. However, RWF_WRITE_LIFE_NOT_SET retained
> "RWF_*" prefix used in earlyy versions of the proposed patch set[3].
> Rename it and provide the old name as a synonym for the new one
> for backward compatibility.
> 
> [1] https://github.com/axboe/fio/commit/bd553af6c849
> [2] https://github.com/mkerrisk/man-pages/commit/580082a186fd
> [3] https://www.mail-archive.com/linux-block@vger.kernel.org/msg09638.html

Looks good, thanks for catching this. One note:

> Fixes: c75b1d9421f8 ("fs: add fcntl() interface for setting/getting write life time hints")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> Signed-off-by: Eugene Syromyatnikov <evgsyr@gmail.com>

Why do you have two separate sign-offs?

-- 
Jens Axboe
