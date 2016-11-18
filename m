From: NeilBrown <neilb@suse.com>
Subject: [PATCH/RFC] add "failfast" support for raid1/raid10.
Date: Fri, 18 Nov 2016 16:16:11 +1100
Message-ID: <147944614789.3302.1959091446949640579.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-raid.ids

Hi,

 I've been sitting on these patches for a while because although they
 solve a real problem, it is a fairly limited use-case, and I don't
 really like some of the details.

 So I'm posting them as RFC in the hope that a different perspective
 might help me like them better, or find a better approach.

 The core idea is that when you have multiple copies of data
 (i.e. mirrored drives) it doesn't make sense to wait for a read from
 a drive that seems to be having problems.  It will probably be faster
 to just cancel that read, and read from the other device.
 Similarly, in some circumstances, it might be better to fail a drive
 that is being slow to respond to writes, rather than cause all writes
 to be very slow.

 The particular context where this comes up is when mirroring across
 storage arrays, where the storage arrays can temporarily take an
 unusually long time to respond to requests (firmware updates have
 been mentioned).  As the array will have redundancy internally, there
 is little risk to the data.  The mirrored pair is really only for
 disaster recovery, and it is deemed better to lose the last few
 minutes of updates in the case of a serious disaster, rather than
 occasionally having latency issues because one array needs to do some
 maintenance for a few minutes.  The particular storage arrays in
 question are DASD devices which are part of the s390 ecosystem.

 Linux block layer has "failfast" flags to direct drivers to fail more
 quickly.  These patches allow devices in an md array to be given a
 "failfast" flag, which will cause IO requests to be marked as
 "failfast" providing there is another device available.  Once the
 array becomes degraded, we stop using failfast, as that could result
 in data loss.

 I don't like the whole "failfast" concept because it is not at all
 clear how fast "fast" is.  In fact, these block-layer flags are
 really a misnomer.  They should be "noretry" flags.
 REQ_FAILFAST_DEV means "don't retry requests which reported an error
 which seems to come from the device.
 REQ_FAILFAST_TRANSPORT means "don't retry requests which seem to
 indicate a problem with the transport, rather than the device"
 REQ_FAILFAST_DRIVER means  .... I'm not exactly sure.  I think it
 means whatever a particular driver wants it to mean, basically "I
 cannot seem to handle this right now, just resend and I'll probably
 be more in control next time".  It seems to be for internal-use only.

 Multipath code uses REQ_FAILFAST_TRANSPORT only, which makes sense.
 btrfs uses REQ_FAILFAST_DEV only (for read-ahead) which doesn't seem
 to make sense.... why would you ever use _DEV without _TRANSPORT?

 None of these actually change the timeouts in the driver or in the
 device, which is what I would expect for "failfast", so to get real
 "fast failure" you need to enable failfast, and adjust the timeouts.
 That is what we do for our customers with DASD.

 Anyway, it seems to make sense to use _TRANSPORT and _DEV for
 requests from md where there is somewhere to fall-back on.
 If we get an error from a "failfast" request, and the array is still
 non-degraded, we just fail the device.  We don't try to repair read
 errors (which is pointless on storage arrays).

 It is assumed that some user-space code will notice the failure,
 monitor the device to see when it becomes available again, and then
 --re-add it.  Assuming the array has a bitmap, the --re-add should be
 fast and the array will become optimal again without experiencing
 excessive latencies.

 My two main concerns are:
  - does this functionality have any use-case outside of mirrored
    storage arrays, and are there other storage arrays which
    occasionally inserted excessive latency (seems like a serious
    misfeature to me, but I know few of the details)?
  - would it be at all possible to have "real" failfast functionality
    in the block layer?  I.e. something that is based on time rather
    than retry count.  Maybe in some cases a retry would be
    appropriate if the first failure was very fast.
    I.e. it would reduce timeouts and decide on retries based on
    elapsed time rather than number of attempts.
    With this would come the question of "how fast is fast" and I
    don't have a really good answer.  Maybe md would need to set a
    timeout, which it would double whenever it got failures on all
    drives.  Otherwise the timeout would drift towards (say) 10 times
    the typical response time.

 So: comments most welcome.  As I say, this does address a genuine
 need.  Just find it hard to like it :-(


Thanks,
NeilBrown

---

NeilBrown (6):
      md/failfast:  add failfast flag for md to be used by some personalities.
      md: Use REQ_FAILFAST_* on metadata writes where appropriate
      md/raid1: add failfast handling for reads.
      md/raid1: add failfast handling for writes.
      md/raid10: add failfast handling for reads.
      md/raid10: add failfast handling for writes.


 drivers/md/bitmap.c            |   15 ++++++--
 drivers/md/md.c                |   71 +++++++++++++++++++++++++++++++-----
 drivers/md/md.h                |   27 +++++++++++++-
 drivers/md/raid1.c             |   79 ++++++++++++++++++++++++++++++++++------
 drivers/md/raid1.h             |    1 +
 drivers/md/raid10.c            |   79 +++++++++++++++++++++++++++++++++++++---
 drivers/md/raid10.h            |    2 +
 include/uapi/linux/raid/md_p.h |    7 +++-
 8 files changed, 249 insertions(+), 32 deletions(-)

--
Signature

