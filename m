From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: md: 'array_size' sysfs attribute
Date: Thu, 5 Feb 2015 14:02:37 +0300
Message-ID: <20150205110237.GA7933@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dan.j.williams@intel.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Dan Williams,

The patch b522adcde9c4: "md: 'array_size' sysfs attribute" from Mar
31, 2009, leads to the following static checker warning:

	drivers/md/md.c:5069 md_run()
	error: we previously assumed 'mddev->pers' could be null (see line 4936)

This code is really old.  I don't know why my stupid scripts are marking
it as a new warning.  We don't set "mddev->pers" to non-NULL until the
end of the function so it looks like a real bug and that "pers->size"
was intended.  When I fix that bug then it un-silences this warning:

	drivers/md/md.c:5080 md_run()
	error: we previously assumed 'mddev->pers' could be null (see line 4936)

And that also is a real bug, but I'm not sure the right fix for that.

Basically, it's bugs all the way down from the code, to the fix, to the
static checker.  *sigh*.

drivers/md/md.c
  5060          err = pers->run(mddev);
  5061          if (err)
  5062                  printk(KERN_ERR "md: pers->run() failed ...\n");
  5063          else if (pers->size(mddev, 0, 0) < mddev->array_sectors) {
  5064                  WARN_ONCE(!mddev->external_size, "%s: default size too small,"
  5065                            " but 'external_size' not in effect?\n", __func__);
  5066                  printk(KERN_ERR
  5067                         "md: invalid array_size %llu > default size %llu\n",
  5068                         (unsigned long long)mddev->array_sectors / 2,
  5069                         (unsigned long long)mddev->pers->size(mddev, 0, 0) / 2);
                                                   ^^^^^^^^^^^^^^^^^^
This should be "pers->size()".

  5070                  err = -EINVAL;
  5071          }
  5072          if (err == 0 && pers->sync_request &&
  5073              (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
  5074                  err = bitmap_create(mddev);
  5075                  if (err)
  5076                          printk(KERN_ERR "%s: failed to create bitmap (%d)\n",
  5077                                 mdname(mddev), err);
  5078          }
  5079          if (err) {
  5080                  mddev_detach(mddev);
                        ^^^^^^^^^^^^^^^^^^^
mddev_detach() will oops if mddev->pers() is not set.  We could set
mdev->pers earlier, I suppose.

  5081                  pers->free(mddev, mddev->private);
  5082                  module_put(pers->owner);
  5083                  bitmap_destroy(mddev);
  5084                  return err;
  5085          }
  5086          if (mddev->queue) {
  5087                  mddev->queue->backing_dev_info.congested_data = mddev;
  5088                  mddev->queue->backing_dev_info.congested_fn = md_congested;
  5089                  blk_queue_merge_bvec(mddev->queue, md_mergeable_bvec);
  5090          }

regards,
dan carpenter
