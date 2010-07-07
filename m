From: Neil Brown <neilb@suse.de>
Subject: Re: power outage while raid5->raid6 was in progress
Date: Thu, 8 Jul 2010 08:44:50 +1000
Message-ID: <20100708084450.7abb19d8@notabene.brown>
References: <20100707204110.GB1207@earth.universe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100707204110.GB1207@earth.universe>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Reichel <elektranox@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 7 Jul 2010 22:41:10 +0200
Sebastian Reichel <elektranox@gmail.com> wrote:

> Hi,
> 
> I have some problems with my raid. I tried updating from 5 disks raid5 to 8 disks
> raid6 as described on http://neil.brown.name/blog/20090817000931#2. The command I
> used was: mdadm --grow /dev/md0 --level=6 --raid-disk=8
> 
> While the rebuild was in progress my system hung, so I had to force power down it.
> After rebooting the system I reassembled the raid. You can see the resulting mess
> below. How can I recover from this state?

Please report the output of

  mdadm -E /dev/sd[efghijkl]1

then I'll see what can be done.

NeilBrown
