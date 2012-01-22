From: Michal Soltys <soltys@ziu.info>
Subject: Re: [PATCH 1/1] Work around gcc-4.7's strict aliasing checks
Date: Sun, 22 Jan 2012 01:49:19 +0100
Message-ID: <1327193360-4446-1-git-send-email-soltys@ziu.info>
References: <20120112104320.471910db@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120112104320.471910db@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids


Below is approach to the "problem" from a bit different angle - using
alias-permitting type definitions consistently where necessary - so assuring
compiler won't (shouldn't ?) pursue any funny ideas no matter what. I'd guess
it's the "right" thing to do - aside from going kernel way and using
-fno-strict-aliasing everywhere (or #pragmas).

The compilation goes cleanly at Wstrict-aliasing=1 - so most aggresive yet most
dumb at the same time (note, not checked on 4.7, but obviously I included
necessary equivalent changes to the Jes's patch).

Anyway - side effects of Wstrict-aliasing=1 are false positives - quite a few
of them actually (funcion argument casts where only pointers are involved, some
pointers which are not dereferenced "nearby" and/or in the same block) - but
false negatives should be (almost ?) nonexistent.  As mdadm is rather critical,
and itself compiled with Wall, Wextra and Werror - I assume to be extra careful
- this should complement those settings well.

On a bad side of this approach - it doesn't necessary make the code prettier,
and might make people ask "the hell is this ...".

About the necessary smokescreens:

- mentioned function calls (mostly posix_memalign()) are out of our control
  (like any other external library provided thing), still gcc will complain
  about argument casts - respecting =1 warning settings. Quieting is simple -
  either single (void *) or (void_pa *). As we actually use the latter typedef
  on a few occasions, so it got used here.

- when may_alias struct is defined, any references to itself inside the
  definition (next/prev pointers, etc.) will "lose" may_alias on the struct.
  Similary, if struct is mentioned before its complete definition - the same
  thing will occur. The latter is the reason why #include "msg.h" was moved
  after mdinfo's related definitions. Also see below:

- some of the uses changes are also needed to avoid "incompatible pointer cast"
  warnings - which show up after adding may_alias types (e.g., gcc will
  consider (__u64 *) and (__u64_a *) as incompatible).

Either way, for your consideration.


Michal Soltys (1):
  compile cleanly with -Wstrict-aliasing=1

 Grow.c        |   14 ++++++------
 Makefile      |    2 +-
 bitmap.h      |    2 +-
 managemon.c   |   13 ++++++-----
 md5.h         |    1 +
 mdadm.h       |   13 +++++++++-
 part.h        |    4 +-
 restripe.c    |   11 ++++++---
 sha1.c        |    8 ++----
 super-ddf.c   |   64 +++++++++++++++++++++++++-------------------------------
 super-gpt.c   |    2 +-
 super-intel.c |   37 +++++++++++++++++----------------
 super-mbr.c   |    4 +-
 super0.c      |   14 +++++++-----
 super1.c      |   17 +++++++++------
 util.c        |    7 +++--
 16 files changed, 113 insertions(+), 100 deletions(-)

-- 
1.7.7.1
