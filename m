From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Tue, 7 Sep 2010 22:00:58 +0200
Message-ID: <201009072200.59509.arnd@arndb.de>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com> <201009062210.56824.arnd@arndb.de> <20100907192154.GA14214@albatros>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100907192154.GA14214@albatros>
Sender: linux-raid-owner@vger.kernel.org
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 07 September 2010 21:21:55 Kulikov Vasiliy wrote:
> #define __rcu_dereference_check(p, c, space) \
>         ({ \
>                 typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
>                                                                    ^
>                 rcu_lockdep_assert(c); \
>                 (void) (((typeof (*p) space *)p) == p); \
>                                       ^     ^
>                 smp_read_barrier_depends(); \
>                 ((typeof(*p) __force __kernel *)(_________p1)); \
>         })
> 
> If I understand this, it is evaluated three times, right?
 
Yes, that looks like my own fault, I added that :(

This patch seems to fix it, but I need to think about it some more
to make sure it still does everything we need.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 89414d6..743bc3f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -313,21 +313,21 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_access_pointer(p, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		(void) (((typeof (*p) space *)p) == p); \
+		(void) (((typeof (*p) space *)NULL) == (typeof(p))NULL); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_check(p, c, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
 		rcu_lockdep_assert(c); \
-		(void) (((typeof (*p) space *)p) == p); \
+		(void) (((typeof (*p) space *)NULL) == (typeof(p))NULL); \
 		smp_read_barrier_depends(); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_protected(p, c, space) \
 	({ \
 		rcu_lockdep_assert(c); \
-		(void) (((typeof (*p) space *)p) == p); \
+		(void) (((typeof (*p) space *)NULL) == (typeof(p))NULL); \
 		((typeof(*p) __force __kernel *)(p)); \
 	})
 
