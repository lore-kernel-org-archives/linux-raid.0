From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Linux 5.5 Breaks Raid1 on Device instead of Partition, Unusable
 I/O
Date: Mon, 2 Mar 2020 10:25:42 +0500
Message-ID: <20200302102542.309e2d19@natsu>
References: <e46b2ae7-3b88-05f2-58d7-94ee3df449e4@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e46b2ae7-3b88-05f2-58d7-94ee3df449e4@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 1 Mar 2020 19:50:03 -0600
"David C. Rankin" <drankinatty@suddenlinkmail.com> wrote:

>   Let me know if there is anything else I can send, and let me know if I
> should stop the scrub or just let it run. I'm happy to run any diagnostic you
> can think of that might help. Thanks.

It doesn't seem convincing that the issue is raw devices vs partitions, or
even kernel version related, especially since you rolled it back and the issue
remains.

What else you could send is "smartctl -a" of all devices;

and most importantly, while the "slow" scrub is running on md4, start:

  iostat -x 2 /dev/sdc /dev/sdd

(enlarge the terminal window) and see if any of the 2 devices is pegged into
100.0 in the last "%util" column, or just showing much higher values there
than the other one.

-- 
With respect,
Roman
