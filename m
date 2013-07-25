From: Wes <wt75@gazeta.pl>
Subject: raid10 centos5 vs. centos6 300% worse random write performance
Date: Thu, 25 Jul 2013 10:11:41 +0000 (UTC)
Message-ID: <loom.20130725T120703-146@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Why raid10 driver from Centos 6 has a 300% slower random write performance
(random read stays the same) than Centos 5?

I run tests on centos 5. 

./seekmark -f /dev/md3 -t 8 -s 1000 -w destroy-data
WRITE benchmarking against /dev/md3 1838736 MB
threads to spawn: 8
seeks per thread: 1000
io size in bytes: 512
write data is randomly generated
Spawning worker 0 to do 1000 seeks
Spawning worker 1 to do 1000 seeks
Spawning worker 2 to do 1000 seeks
Spawning worker 3 to do 1000 seeks
Spawning worker 4 to do 1000 seeks
Spawning worker 5 to do 1000 seeks
Spawning worker 6 to do 1000 seeks
Spawning worker 7 to do 1000 seeks
thread 5 completed, time: 39.75, 25.16 seeks/sec, 39.8ms per request
thread 1 completed, time: 40.99, 24.39 seeks/sec, 41.0ms per request
thread 7 completed, time: 41.35, 24.18 seeks/sec, 41.4ms per request
thread 4 completed, time: 41.59, 24.04 seeks/sec, 41.6ms per request
thread 2 completed, time: 41.69, 23.99 seeks/sec, 41.7ms per request
thread 3 completed, time: 41.90, 23.87 seeks/sec, 41.9ms per request
thread 0 completed, time: 42.23, 23.68 seeks/sec, 42.2ms per request
thread 6 completed, time: 42.24, 23.67 seeks/sec, 42.2ms per request

total time: 42.26, time per WRITE request(ms): 5.282
189.31 total seeks per sec, 23.66 WRITE seeks per sec per thread

Then installed centos 6 (the same kickstart just ISO changed) preserving
partitons.
I created raid10 with the same command as on centos 5 (mdadm -C /dev/md3
-e0.9 -n4 -l10 -pf2 -c2048 /dev/sda4 /dev/sdb4 /dev/sdc4 /dev/sdd4)
When resync completed I run the same test command and got:

WRITE benchmarking against /dev/md3 1838736 MB
threads to spawn: 8
seeks per thread: 1000
io size in bytes: 512
write data is randomly generated
Spawning worker 0 to do 1000 seeks
Spawning worker 1 to do 1000 seeks
Spawning worker 2 to do 1000 seeks
Spawning worker 3 to do 1000 seeks
Spawning worker 4 to do 1000 seeks
Spawning worker 5 to do 1000 seeks
Spawning worker 6 to do 1000 seeks
Spawning worker 7 to do 1000 seeks
thread 5 completed, time: 118.53, 8.44 seeks/sec, 118.5ms per request
thread 7 completed, time: 122.78, 8.14 seeks/sec, 122.8ms per request
thread 3 completed, time: 124.16, 8.05 seeks/sec, 124.2ms per request
thread 0 completed, time: 125.71, 7.95 seeks/sec, 125.7ms per request
thread 6 completed, time: 125.75, 7.95 seeks/sec, 125.7ms per request
thread 4 completed, time: 125.78, 7.95 seeks/sec, 125.8ms per request
thread 2 completed, time: 126.58, 7.90 seeks/sec, 126.6ms per request
thread 1 completed, time: 126.80, 7.89 seeks/sec, 126.8ms per request

total time: 126.81, time per WRITE request(ms): 15.851
63.09 total seeks per sec, 7.89 WRITE seeks per sec per thread

I recreated the array with all mdadm metas (0.9 1.2 1.1) - still the same
poor random write performance.

Please share your ideas.


