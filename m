From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: [PATCH 0/2] Fix typo in RWH_WRITE_LIFE_NOT_SET constant name
Date: Sat, 6 Oct 2018 19:51:14 +0200
Message-ID: <20181006175114.GA10435@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Hello.

This is a small fix of a typo (or, more specifically, some remnant of
the old patch version spelling) in RWH_WRITE_LIFE_NOT_SET constant,
which is named as RWF_WRITE_LIFE_NOT_SET currently.  Since the name
with "H" is used in man page and everywhere else, it's probably worth
to make the name used in the fcntl.h UAPI header in line with it.
Second follow-up patch updates (the sole) usage site of this constant
in kernel to use the new spelling.

The old name is retained as it is part of UAPI now.

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
