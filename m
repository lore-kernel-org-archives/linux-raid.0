From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH 0/2] Fix some building errors
Date: Wed,  1 Mar 2017 15:07:42 +0800
Message-ID: <1488352062-32157-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@gmail.com, ncroxon@redhat.com
List-Id: linux-raid.ids

Hi Jes

There are some error buildings in Fedora release 26 (Rawhide)
The gcc version is gcc (GCC) 7.0.1 20170211 (Red Hat 7.0.1-0.8)

There are three types of errors:
1. Fall through 
mdadm.c:149:28: error: this statement may fall through [-Werror=implicit-fallthrough=]
2. format-overflow
Detail.c: In function Detail:
Detail.c:584:31: error: directive writing up to 255 bytes into 
a region of size 189 [-Werror=format-overflow=]
3. format-truncation
super-intel.c: In function examine_super_imsm:
super-intel.c:1815:30: error: directive output may be truncated 
writing up to 31 bytes into a region of size 24 [-Werror=format-truncation=]

Xiao Ni (2):
  Add Wimplicit-fallthrough=0 in Makefile
  Specify suitable size when write to buffer

 Detail.c      | 2 +-
 Makefile      | 2 +-
 super-intel.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.7.4

