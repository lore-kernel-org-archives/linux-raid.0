From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: extremely tiny race window in raid1
Date: Tue, 11 Jan 2005 20:52:22 +0100
Message-ID: <mcndb2-6m8.ln1@news.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 From raid1.c in 2.6.8.1:

         * inc refcount on their rdev.  Record them by setting
         * bios[x] to bio
         */
-       disks = conf->raid_disks;
        spin_lock_irq(&conf->device_lock);
+       disks = conf->raid_disks;
        for (i = 0;  i < disks; i++) {
                if (conf->mirrors[i].rdev &&
                    !conf->mirrors[i].rdev->faulty) {

(there are plenty of other places where small things like that happen,
and normally I say "shucks, he'll spot it and correct it, and it's no
biggie anyway", but my conscience is getting at me to report at least
some of them).


Peter

