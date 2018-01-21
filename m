From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH V2 1/3] mdadm: improve the dlm locking mechanism for
 clustered raid
Date: Sun, 21 Jan 2018 16:08:40 -0500
Message-ID: <a0866324-08b1-177a-a64d-448ddee3b9cc@gmail.com>
References: <20180103081911.7380-1-gqjiang@suse.com>
 <20180103081911.7380-2-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180103081911.7380-2-gqjiang@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/03/2018 03:19 AM, Guoqing Jiang wrote:
> Previously, the dlm locking only protects several
> functions which writes to superblock (update_super,
> add_to_super and store_super), and we missed other
> funcs such as add_internal_bitmap. We also need to
> call the funcs which read superblock under the
> locking protection to avoid consistent issue.
> 
> So let's remove the dlm stuffs from super1.c, and
> provide the locking mechanism to the main() except
> assemble mode which will be handled in next commit.
> And since we can identify it is a clustered raid or
> not based on check the different conditions of each
> mode, so the change should not have effect on native
> array.

Hi,

Sorry for not getting to this earlier, it's been a little hectic that
last couple of months.

I am still not happy with the lock_cluster() stuff.

In super1.c every time you call cluster_get_dlmlock() it includes a
prior call to dlm_funs_ready():

        if (bms->version == BITMAP_MAJOR_CLUSTERED && dlm_funs_ready()) {
                rv = cluster_get_dlmlock(&lockid);
                if (rv) {
                        pr_err("Cannot get dlmlock in %s return %d\n",
                               __func__, rv);
                        cluster_release_dlmlock(lockid);
                        return rv;
                }
        }

You only call lock_cluster() in one place, and lock cluster does exactly
the same:

+int lock_cluster(void)
+{
+	if (dlm_funs_ready()) {
+		int rv;
+
+		rv = cluster_get_dlmlock();
+		if (rv) {
+			pr_err("failed to lock cluster\n");
+			return -1;
+		}
+		return 1;
+	}
+	pr_err("Something wrong with dlm library\n");
+	return 0;
+}

If you stick the dlm_funs_ready() check into cluster_get_dlmlock() and
call it directly it will simplify the code by not introducing the
unnecessary lock_cluster()/unclock_cluster() functions and in super1.c.
I really hate this introducing a new silly state 0/1 returned from
lock_cluster(), just check whether you got a valid lock back or not.

Cheers,
Jes
