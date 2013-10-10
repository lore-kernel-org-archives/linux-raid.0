From: Jes.Sorensen@redhat.com
Subject: [PATCH 0/1] consistent return types from byteswap macros
Date: Thu, 10 Oct 2013 09:42:04 +0200
Message-ID: <1381390925-9033-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, karsten@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

There are multiple ways to solve this one, but I think this is the
least intrusive solution, even if not the prettiest.

Problem is that current macros simply return the original value if cpu
byteorder equals the converted type, leaking through the original
type. This results in errors like this when building for PPC64, as an
example:

gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches  -m64 -DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\"   -DUSE_PTHREADS   -c -o super-intel.o super-intel.c
super-ddf.c: In function 'examine_vd':
super-ddf.c:1414:10: error: format '%llu' expects argument of type 'long long unsigned int', but argument 3 has type '__u64' [-Werror=format=]
          be64_to_cpu(vc->blocks)/2);
          ^

We could force the macros to all return u16/u32/u64, which would be
'cleaner'. However I suspect that would make us chase a pile of build
warnings converting all printf's to explicitly cast. So I made them
return the same types as our byteswap macros default to (hence the
unsigned int return type for the 16 bit swaps).

Jes


Jes Sorensen (1):
  Be consistent in return types from byteswap macros

 mdadm.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

-- 
1.8.3.1

