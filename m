From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] Revert "md: raid1: use bio helper in process_checks()"
Date: Sat, 1 Apr 2017 18:51:18 -0300
Message-ID: <20170401215118.GB31653@khazad-dum.debian.net>
References: <20170328095029.3500369-1-arnd@arndb.de>
 <CACVXFVMX=0XBvSt7b-3XObw3SknPGqH9JZvT6jViYbZfzKqQEg@mail.gmail.com>
 <CAK8P3a0k9S-t1CvpcabNVJOFMWoieuSn6EEr4oB72+T=zQT=aw@mail.gmail.com>
 <CACVXFVNzGV+P9CXcyqcV0_rJVM9F7dOR3_aX2xv0GQTsMaXX6A@mail.gmail.com>
 <CAK8P3a1yV0M_3TwM2QkEKqL-teKNEcWRXuG4_GT27pM+rFoBPw@mail.gmail.com>
 <CACVXFVMWORnxVtuokRp=N1ELAk4UbkOr0n-hM2MOTbO7HLhLtw@mail.gmail.com>
 <58DA848B.7030308@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <58DA848B.7030308@youngman.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Ming Lei <tom.leiming@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@fb.com>, "colyli@suse.de" <colyli@suse.de>, Guoqing Jiang <gqjiang@suse.com>, Mike Christie <mchristi@redhat.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 28 Mar 2017, Wols Lists wrote:
> What Arnd is doing is commonly called "defensive programming", and
> unfortunately reality shows us that it is usually worth its weight in
> gold. That's why you put ASSERTs in code - so that if somebody does
> something stupid by accident, it blows up. This is just more of the same.

You know, BUG_ON(vcnt1 != vcnt2) might address this quite nicely [if you
want to go the assert() way, that is!], since __attribute__((noreturn))
is set for the codepath taken when the BUG_ON condition triggers...

That said, if there is something less insane to be done than OOPsing
when the world has gone strange and vcnt1 != vcnt2, that ought to be a
better solution...

All of this assumes vcnt1 == vcnt2 is really the only possibily correct
situation.

-- 
  Henrique Holschuh
