From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: [PATCH v3 0/3] Fix typo in RWH_WRITE_LIFE_NOT_SET constant name
Date: Fri, 20 Sep 2019 17:58:13 +0200
Message-ID: <cover.1568994791.git.esyr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Hello.

This is a small fix of a typo (or, more specifically, some remnant of
the old patch version spelling) in RWH_WRITE_LIFE_NOT_SET constant,
which is named as RWF_WRITE_LIFE_NOT_SET currently.  Since the name
with "H" is used in man page and everywhere else, it's probably worth
to make the name used in the fcntl.h UAPI header in line with it.
The two follow-up patches update usage sites of this constant in kernel
to use the new spelling.

The old name is retained as it is part of UAPI now.

Changes since v2[1]:
 * Updated RWF_WRITE_LIFE_NOT_SET constant usage
   in drivers/md/raid5-ppl.c:ppl_init_log().

Changes since v1[2]:
 * Changed format of the commit ID in the commit message of the first patch.
 * Removed bogus Signed-off-by that snuck into the resend of the series.

[1] https://lkml.org/lkml/2018/10/30/34
[2] https://lkml.org/lkml/2018/10/26/88

Eugene Syromiatnikov (3):
  fcntl: fix typo in RWH_WRITE_LIFE_NOT_SET r/w hint name
  drivers/md/raid5.c: use the new spelling of RWH_WRITE_LIFE_NOT_SET
  drivers/md/raid5-ppl.c: use the new spelling of RWH_WRITE_LIFE_NOT_SET

 drivers/md/raid5-ppl.c           | 2 +-
 drivers/md/raid5.c               | 4 ++--
 fs/fcntl.c                       | 2 +-
 include/uapi/linux/fcntl.h       | 9 ++++++++-
 tools/include/uapi/linux/fcntl.h | 9 ++++++++-
 5 files changed, 20 insertions(+), 6 deletions(-)

-- 
2.1.4
