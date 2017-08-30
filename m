From: Ming Lei <ming.lei@redhat.com>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Wed, 30 Aug 2017 13:17:31 +0800
Message-ID: <20170830051725.GA5840@ming.t460p>
References: <3926917.BCSovyVWdL@natalenko.name>
 <1615033.Xza1AIGLzP@natalenko.name>
 <20170829002425.GA28904@ming.t460p>
 <2329566.kid2YYBOAQ@natalenko.name>
 <20170830021537.GA4897@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170830021537.GA4897@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On Wed, Aug 30, 2017 at 10:15:37AM +0800, Ming Lei wrote:
> Hi,
> 
> On Tue, Aug 29, 2017 at 05:52:42PM +0200, Oleksandr Natalenko wrote:
> > Hello.
> > 
> > Re-tested with v4.13-rc7 + proposed patch and got the same result.
> 
> Maybe there is another issue, I didn't use dmcrypt on raid10, will
> test in your way to see if I can reproduce it.
> 
> BTW, could you share us which blk-mq scheduler you are using on sata?
> The patch I posted should address one issue on none scheduler.

Can't reproduce even with putting dmcypt on raid10 after applying
my patch.

Could you apply the following debug patch and provide the dmesg log
after running the commands below?

	# echo 9 > /proc/sys/kernel/printk
	# echo devices > /sys/power/pm_test
	# echo mem > /sys/power/state

BTW, it is better to provide the two sata disk(behind raid10) name.

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index b44c1bb687a2..75b13248ea1c 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -53,17 +53,22 @@ static int scsi_dev_type_suspend(struct device *dev,
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int err;
+	struct scsi_device *sdev = to_scsi_device(dev);
 
 	/* flush pending in-flight resume operations, suspend is synchronous */
 	async_synchronize_full_domain(&scsi_sd_pm_domain);
 
-	err = scsi_device_quiesce(to_scsi_device(dev));
+	sdev_printk(KERN_WARNING, sdev, "%s: enter\n", __func__);
+	err = scsi_device_quiesce(sdev);
 	if (err == 0) {
+		sdev_printk(KERN_WARNING, sdev, "%s: before suspend\n", __func__);
 		err = cb(dev, pm);
+		sdev_printk(KERN_WARNING, sdev, "%s: after suspend\n", __func__);
 		if (err)
-			scsi_device_resume(to_scsi_device(dev));
+			scsi_device_resume(sdev);
 	}
 	dev_dbg(dev, "scsi suspend: %d\n", err);
+	sdev_printk(KERN_WARNING, sdev, "%s: exit\n", __func__);
 	return err;
 }
 
@@ -72,9 +77,13 @@ static int scsi_dev_type_resume(struct device *dev,
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int err = 0;
+	struct scsi_device *sdev = to_scsi_device(dev);
 
+	sdev_printk(KERN_WARNING, sdev, "%s: enter\n", __func__);
+	sdev_printk(KERN_WARNING, sdev, "%s: before resume\n", __func__);
 	err = cb(dev, pm);
-	scsi_device_resume(to_scsi_device(dev));
+	sdev_printk(KERN_WARNING, sdev, "%s: after resume\n", __func__);
+	scsi_device_resume(sdev);
 	dev_dbg(dev, "scsi resume: %d\n", err);
 
 	if (err == 0) {
@@ -83,6 +92,7 @@ static int scsi_dev_type_resume(struct device *dev,
 		pm_runtime_enable(dev);
 	}
 
+	sdev_printk(KERN_WARNING, sdev, "%s: exit\n", __func__);
 	return err;
 }


-- 
Ming
