From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: possible HighPoint RocketRAID 2720SGL failure
Date: Thu, 21 Sep 2017 21:12:36 +1000
Message-ID: <73afd1f8-176a-07e9-1024-57692dc96904@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I wonder if anyone had this happen or is familiar with such a situation.

I have a HighPoint RocketRAID 2720SGL controller managing 7 disks in a software RAID6.
So far it was running smoothly for about 4 years. Recently, at one point all the disks
disappeared.

Looking at the logs I could see that the disks completely stopped responding and
3 minutes later all reported read failures and the raid dropped to 0 out of 7 up.

The disks do not have proper error handling to they are set to 180s timeout (at boot time).
I think this accounts for the 3 minutes delay between no response and disk errors logged.

It looks like the controller failed as all 7 disks disappeared together and did not respond
to any i/o or even smart.

After power off/on things look OK. The raid6 did a very short recovery, then the ext4 fs did
a quick recovery. fsck found no problems.

I later started a raid 'check' but it failed in less that an hour (out of 10) in the same way.
A day later I tried again and it failed within 15 minutes.

So far it looks like nothing was lost but I am uncomfortable with this situation.
No surprise here...

The controller did not log any errors.

Does this look familiar to anyone?

TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
