From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Scrubbing "check" not working for RAID10 in 3.10-rc1+
Date: Tue, 25 Jun 2013 01:19:20 -0500
Message-ID: <1372141160.2016.0.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

I've noticed that the "check" operation no longer works for RAID10.  It
works just fine for the other RAIDs.  The ("data-check") sync_thread
kicks off just fine, sync_request_write() is called, but it never gets
past:
        if (i == conf->copies)
                goto done;
The test I am performing creates a RAID array, waits for it to sync,
shuts it down, writes random data to one of the devices, assembles the
array, and then runs a "check" - there should be descrepancies.  The
descrepancies are found and recorded in resync_mismatches for all RAIDs
<= 3.9 and only for non-RAID10 3.10-rc1+.

I'm sorry I haven't tracked it down yet and I'm going to be on vacation
starting tomorrow with only intermittent access to e-mail.  Sorry to
leave you hanging.

Thanks,
 brassow

P.S.  This also reminded me of a patch I have concerning tracking the
last sync action for the purpose of making mismatch_count more useful.
I'll post that before leaving.


