From: =?utf-8?Q?Rainer_F=C3=BCgenstein?= <rfu@oudeis.org>
Subject: Re: performance issue (was: Re: kernel: BUG: soft lockup - CPU#1 stuck for 60s!)
Date: Sun, 25 Oct 2015 20:23:37 +0100
Message-ID: <16514313.20151025202337@oudeis.org>
References: <1092031595.20151015153830@oudeis.org>
  <87si5bvcj4.fsf@notabene.neil.brown.name> <43246687.20151024181541@oudeis.org>
  <20151024213139.5b20dec6@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151024213139.5b20dec6@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Neil Brown <nfbrown@novell.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Roman,

Saturday, October 24, 2015, 6:31:39 PM, you wrote:

> Use a higher bitmap-chunk size, such as 256M or more.

I guess that would be

   mdadm --grow /dev/md0 --bitmap-chunk=256M    ??

is  it  wise  to issue this command during a re-sync?

a  cron.weekly  job started the re-sync (although I'm pretty sure this
job has been disabled quite some time ago)

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb1[7] sdf1[3] sdc1[5] sde1[0] sdd1[8]
      11721061376 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
      [==>..................]  resync = 11.9% (348948608/2930265344) finish=7771.1min speed=5533K/sec
      bitmap: 8/350 pages [32KB], 4096KB chunk

unused devices: <none>

tnx & cu

-- 
Best regards,
 Rainer                            mailto:rfu@oudeis.org

