From: "martin f. krafft" <madduck@debian.org>
Subject: [solved] Bug#444682: mdadm segfault at super1.c:1004
Date: Sun, 30 Sep 2007 13:22:55 +0100
Message-ID: <1191154976-12311-1-git-send-email-madduck@debian.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 20070930113456.GA8924@lapse.madduck.net
References: 20070930113456.GA8924@lapse.madduck.net
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: 444682-submitter@bugs.debian.org
List-Id: linux-raid.ids

also sprach martin f krafft <madduck@debian.org> [2007.09.30.1234 +0100]:
> Oh well, I think this is an amd64-specific problem. Daniel, are you
> around today to debug this? Or anyone else with amd64? I don't have
> an amd64 machine around to test this for another three weeks, so I'd
> really appreciate if someone else stepped in.

Okay, I did find one and I can reproduce. First thing to note:

#535 0x000000000041f07c in load_super1 (st=0x634030, fd=8, sbp=0x7fff9f4fefd0, 
    devname=0x0) at super1.c:1005
#536 0x000000000041f07c in load_super1 (st=0x634030, fd=8, sbp=0x7fff9f4fefd0, 
    devname=0x0) at super1.c:1005

load_super1 apparently recurses infinitely. Looking at the code:

  static int load_super1(struct supertype *st, int fd, void **sbp, char *devname)
  {
          unsigned long long dsize;
          unsigned long long sb_offset;
          struct mdp_superblock_1 *super;
          int uuid[4];
          struct bitmap_super_s *bsb;
          struct misc_dev_info *misc;

          if (st->ss == NULL || st->minor_version == -1) {
                  int bestvers = -1;
                  struct supertype tst;
                  __u64 bestctime = 0;
                  /* guess... choose latest ctime */
                  tst.ss = &super1;
                  for (tst.minor_version = 0; tst.minor_version <= 2 ; tst.minor_version++) {
                          switch(load_super1(st, fd, sbp, devname)) {

I can't help but note that there is no way to break out of this
loop if (st->ss == NULL || st->minor_version == -1) is true when
it's called the first time.

So it turns out that I think Neil simply forgot to replace the first
argument by &tst in commit a40b4fe, as the forthcoming patch does.

-- 
 .''`.   martin f. krafft <madduck@debian.org>
: :'  :  proud Debian developer, author, administrator, and user
`. `'`   http://people.debian.org/~madduck - http://debiansystem.info
  `-  Debian - when you have better things to do than fixing systems
 
because light travels faster than sound,
some people appear to be intelligent,
until you hear them speak.
