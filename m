From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Advice please re failed Raid6
Date: Sun, 16 Jul 2017 05:58:08 +0500
Message-ID: <20170716055808.4b96b4bc@natsu>
References: <9dca5b7a-b60e-0e93-41fd-49d092d8b27b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9dca5b7a-b60e-0e93-41fd-49d092d8b27b@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bogo Mipps <bogo.mipps@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

One thing that I spotted:

Jun 27 16:52:21 keruru kernel: [ 2.922808] md: kicking non-fresh sdb from array!
Jun 27 16:52:21 keruru kernel: [ 3.173236] md/raid:md0: device sdd operational as raid disk 1
Jun 27 16:52:21 keruru kernel: [ 3.173239] md/raid:md0: device sde operational as raid disk 3
Jun 27 16:52:21 keruru kernel: [ 3.173242] md/raid:md0: device sdc operational as raid disk 2

The disk order here was "b d c e"

Jul 6 09:45:52 keruru kernel: [ 1195.580003] md/raid:md0: device sdb operational as raid disk 0
Jul 6 09:45:52 keruru kernel: [ 1195.580012] md/raid:md0: device sde operational as raid disk 3
Jul 6 09:45:52 keruru kernel: [ 1195.580018] md/raid:md0: device sdd operational as raid disk 2
Jul 6 09:45:52 keruru kernel: [ 1195.580025] md/raid:md0: device sdc operational as raid disk 1

But here the order changes to "b c d e"

Unless this is across reboots and your hardware detects disks in a random
order, something weird is going on here.

Also, your array has creation time of "Fri Jun 30 15:42:27 2017", but you
provide no dmesg or logs from that date.
Maybe you forgot to use --assume-clean on one of the attempts (and that's when
you nuked the array entirely)?
Or perhaps --assume-clean also rewrites the creation date, I am not sure.

-- 
With respect,
Roman
