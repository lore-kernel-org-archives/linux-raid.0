From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: [PATCH v2 0/2] Fix typo in RWH_WRITE_LIFE_NOT_SET constant name
Date: Mon, 29 Oct 2018 21:00:45 +0100
Message-ID: <cover.1540843065.git.esyr@redhat.com>
References: <cdbbf807-4df6-58c9-7d9c-2aeb1727c157@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cdbbf807-4df6-58c9-7d9c-2aeb1727c157@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

This is a small fix of a typo (or, more specifically, some remnant of
the old patch version spelling) in RWH_WRITE_LIFE_NOT_SET constant,
which is named as RWF_WRITE_LIFE_NOT_SET currently.  Since the name
with "H" is used in man page and everywhere else, it's probably worth
to make the name used in the fcntl.h UAPI header in line with it.
Second follow-up patch updates (the sole) usage site of this constant
in kernel to use the new spelling.

The old name is retained as it is part of UAPI now.

Changes since v1:
 * Changed format of the commit ID in the commit message of the first patch.
 * Removed bogus Signed-off-by that snuck into the resend of the series.

Eugene Syromiatnikov (2):
  fcntl: fix typo in RWH_WRITE_LIFE_NOT_SET r/w hint
  drivers/md/raid5.c: use the new spelling of RWH_WRITE_LIFE_NOT_SET

 drivers/md/raid5.c               | 4 ++--
 fs/fcntl.c                       | 2 +-
 include/uapi/linux/fcntl.h       | 9 ++++++++-
 tools/include/uapi/linux/fcntl.h | 9 ++++++++-
 4 files changed, 19 insertions(+), 5 deletions(-)

-- 
2.1.4
