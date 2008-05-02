From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Can't get rid of RAID-5 mismatches
Date: Thu, 1 May 2008 17:21:11 -0700
Message-ID: <e9c3a7c20805011721s3fd9f519hd5efb19820a4542d@mail.gmail.com>
References: <20080501211933.8466.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080501211933.8466.qmail@science.horizon.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>, Linus Torvalds <torvalds@linux-foundation.org>, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Stable <stable@kernel.org>
List-Id: linux-raid.ids

On Thu, May 1, 2008 at 2:19 PM, George Spelvin <linux@horizon.com> wrote:
[..]
>  But let me just ask... the RAID-5 repair code is known to work, right?
>  So the situation I've got above points to some lower-level problem?
>  It's not just somehow forgetting to write out the corrections and
>  I'm seeing the same mismatches over and over again?
>
>  Any other debugging suggestions?

I can reproduce this here, and until I can track down what happened
the fix is reverting commit bd2ab67030e9116f1e4aae1289220255412b37fd
"md: close a livelock window in handle_parity_checks5".

That fix was tested to close a livelock condition for which I had a
reproducible test case, but I did not regression test 'echo repair >
sync_action'.  My fear was that this compromised re-adding a dirty
disk to a degraded array but that appears unaffected.

$ mdadm --create /dev/md0 /dev/loop[0-3] -n 4 -l5
mdadm: array /dev/md0 started.
$ dd if=/dev/zero of=/dev/md0 #initialize with a known pattern
dd: writing to `/dev/md0': No space left on device
153217+0 records in
153216+0 records out
78446592 bytes (78 MB) copied, 1.64838 s, 47.6 MB/s
$ md5sum /dev/md0 # we should get this same checksum later on
82eb2aa05c6736d9215c430aa31f7cf3  /dev/md0
$ mdadm --fail /dev/md0 /dev/loop0
mdadm: set /dev/loop0 faulty in /dev/md0
$ mdadm --remove /dev/md0 /dev/loop0
mdadm: hot removed /dev/loop0
$ dd if=/data_dir/datafile of=/dev/loop0 oflag=sync #dirty the failed disk
dd: writing to `/dev/loop0': No space left on device
51201+0 records in
51200+0 records out
26214400 bytes (26 MB) copied, 2.89976 s, 9.0 MB/s
$ mdadm --add /dev/md0 /dev/loop0
mdadm: added /dev/loop0
$ echo 1 > /proc/sys/vm/drop_caches
$ md5sum /dev/md0
82eb2aa05c6736d9215c430aa31f7cf3  /dev/md0 # recovery successful

--
Dan
