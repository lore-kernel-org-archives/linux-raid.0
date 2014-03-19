From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] Work around systems defining statfs.f_type as long
Date: Wed, 19 Mar 2014 14:26:01 +0100
Message-ID: <1395235562-24672-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, arnd@arndb.de, ralf@linux-mips.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi

I was scratching my head over this build failure on s390x - thanks to
Arnd for suggesting the solution.

Allowing RAMFS_MAGIC to be defined as a number > 31 bits was a mistake
from the beginning, but trying to change it now is probably going to
cause even more headaches.

The problem is that some architectures, such as s390x and MIPS, define
statfs.f_type as signed long, which means the cast to unsigned long
and then comparing it against RAMFS_MAGIC is going to fail.  Instead
this patch brutally casts both to unsigned long and then masks off the
lower 32 bits and comparing those - this avoids having to add #ifdef
cases to the code.

Cheers,
Jes

Jes Sorensen (1):
  Work around architectures having statfs.f_type defined as long

 util.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
1.8.5.3

