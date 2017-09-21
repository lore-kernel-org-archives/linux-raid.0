From: Roman Mamedov <rm@romanrm.net>
Subject: Re: possible HighPoint RocketRAID 2720SGL failure
Date: Thu, 21 Sep 2017 17:20:19 +0500
Message-ID: <20170921172019.2067e49b@natsu>
References: <73afd1f8-176a-07e9-1024-57692dc96904@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73afd1f8-176a-07e9-1024-57692dc96904@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 21 Sep 2017 21:12:36 +1000
Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

> It looks like the controller failed as all 7 disks disappeared together and did not respond
> to any i/o or even smart.
> 
> After power off/on things look OK. The raid6 did a very short recovery, then the ext4 fs did
> a quick recovery. fsck found no problems.
> 
> I later started a raid 'check' but it failed in less that an hour (out of 10) in the same way.
> A day later I tried again and it failed within 15 minutes.
> 
> So far it looks like nothing was lost but I am uncomfortable with this situation.
> No surprise here...
> 
> The controller did not log any errors.
> 
> Does this look familiar to anyone?

The controller is based on the Marvell 9485 chip and Marvell SATA/RAID
controllers seem to have a bad reputation for reliability:

https://www.jethrocarr.com/2013/11/24/adventures-in-io-hell/
https://www.youtube.com/watch?v=010urq9wY3A

I have also faced some CRC errors or disk drop-outs/reconnects on 9123 cards,
and in one case all disks (or possibly the controller itself) disappear from
the system until reboot on a 88SX7042 based controller.

-- 
With respect,
Roman
