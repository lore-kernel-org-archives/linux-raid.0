From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Tue, 11 Jan 2005 12:34:58 +0100
Message-ID: <28qcb2-15v.ln1@news.it.uc3m.es>
References: <41E17117.2090500@tls.msk.ru> <200501092028.j09KSr918180@www.watkins-home.com> <jsh8b2-5g6.ln1@news.it.uc3m.es> <jsm9b2-iqp.ln1@news.it.uc3m.es> <i69ab2-onm.ln1@news.it.uc3m.es> <p0cab2-s27.ln1@news.it.uc3m.es> <okuab2-u4c.ln1@news.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm looking for a natural way to rewrite failed read sectors on read1. ANy
ideas? There are several pitfalls to do with barriers in the different
raid threads.

My first crude idea was to put into raid1_end_request a

   sync_request(mddev, r1_bio->sector, 0);

just before raid1_end_bio_io(r1_bio) is run on a succesful retried
read. But this supposes that nothing in sync_request will sleep (or
is that ok in end_request nowadays). If not possible inline I will
have to schedule it instead.

Another possibility is not to run raid1_end_bio_io just yet but instead
convert the r1_bio we just did ok into a SPECIAL and put it on the retry
queue and let the raid1 treat it (by running the WRITE half of a
READ-WRITE resync operation on it).  I can modify raid1d to do the
users end_bio_io for us if needed. Or I can run

   sync_request_write(mddev, r1_bio);

directly (somehow I get a shiver down my spine) from the end_request.

Ideas? Advice? Derision?

OK - so to be definite, what would be wrong with

        r1_bio->cmd = SPECIAL;
        reschedule_retry(r1_bio);

instead of 

        raid_end_bio_io(r1_bio);

in raid1_end_request? This should result in the raid1d thread doing a
write-half to all devices from the bio buffer taht we just filled with
a successful read.  The question is when we get to ack the user on the
read.  Maybe I should clone the bio.

Peter

