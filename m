From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: GET_ARRAY_INFO assumptions?
Date: Thu, 13 Apr 2017 13:50:06 -0400
Message-ID: <ab07d303-85fb-e912-e4fa-9ee66a1277cc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Looking at trying to phase out the ioctl usage, I am trying to introduce 
a helper for the 'is the array valid' situation.

Now looking at places like Incremental.c (around like 557 in my current 
tree):
	/* 7b/ if yes, */
	/* - if number of OK devices match expected, or -R and there */
	/*             are enough, */
	/*   + add any bitmap file  */
	/*   + start the array (auto-readonly). */

	if (md_get_array_info(mdfd, &ainf) == 0) {
		if (c->export) {
			printf("MD_STARTED=already\n");
		} else if (c->verbose >= 0)
			pr_err("%s attached to %s which is already active.\n",
			       devname, chosen_name);
		rv = 0;
		goto out_unlock;
	}

I am wondering if there are any side effects/assumptions about 
GET_ARRAY_INFO that I am not considering? Basically I am making the 
assumption that if /sys/block/md<X>/md exists, the array is valid.

The code in Incremental.c already deals with sysfs higher up in the 
code, so I guess the question is if the above test is even relevant anymore?

Alternative, do we need export a new state in sysfs 'running'?

Thoughts?

Jes

diff --git a/util.c b/util.c
index a695c45..99ed015 100644
--- a/util.c
+++ b/util.c
@@ -200,6 +200,22 @@ out:
         return ret;
  }

+int md_valid_array(int fd)
+{
+       struct mdinfo *sra;
+       struct mdu_array_info_s array;
+       int ret;
+
+       sra = xcalloc(1, sizeof(*sra));
+       ret = sysfs_init(sra, fd, NULL);
+       free(sra);
+
+       if (ret)
+               ret = ioctl(fd, GET_ARRAY_INFO, &array);
+
+       return !ret;
+}
+
  /*
   * Get array info from the kernel. Longer term we want to deprecate the
   * ioctl and get it from sysfs.
