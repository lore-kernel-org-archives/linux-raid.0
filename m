From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: INFO: task pdflush:393 blocked for more than 120 seconds. & Call
  traces ... (fwd)
Date: Tue, 22 Jul 2008 12:57:18 +1200
Message-ID: <4885306E.1030208@sauce.co.nz>
References: <Pine.LNX.4.64.0807210936410.7212@filesrv1.baby-dragons.com> <18565.6095.988483.628391@notabene.brown> <Pine.LNX.4.64.0807211529350.7212@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807211529350.7212@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mr. James W. Laferriere wrote:

>>> INFO: task pdflush:393 blocked for more than 120 seconds.
>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
>>> message.

I see similar things now during resyncs and a few times during md RAID 
"checks", since kernel 2.6.25.6-55.fc9.x86_64 on md RAID6 and XFS.

See : http://marc.info/?l=linux-raid&m=121408071129399&w=2

Regards,

Richard
