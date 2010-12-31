From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Re: Why won't mdadm start several RAIDs that appear to be
  fine? SOLVED!
Date: Thu, 30 Dec 2010 20:51:30 -0700
Message-ID: <20101231035229.C602BE3098B@mail.futurelabusa.com>
References: <20101230082356.GC2986@bitwizard.nl>
 <4D1C470E.4080406@crc.id.au>
 <20101230094230.GE2986@bitwizard.nl>
 <4D1C616D.8030904@hardwarefreak.com>
 <4D1C73D4.6050600@anonymous.org.uk>
 <4D1C851B.3040304@hardwarefreak.com>
 <20101230232227.96C1CE30991@mail.futurelabusa.com>
 <20101231120816.6b87fa2e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101231120816.6b87fa2e@notabene.brown>
References: <20101230082356.GC2986@bitwizard.nl>
 <4D1C470E.4080406@crc.id.au>
 <20101230094230.GE2986@bitwizard.nl>
 <4D1C616D.8030904@hardwarefreak.com>
 <4D1C73D4.6050600@anonymous.org.uk>
 <4D1C851B.3040304@hardwarefreak.com>
 <20101230232227.96C1CE30991@mail.futurelabusa.com>
 <20101231120816.6b87fa2e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All-

Using yum/rpm to remove dmraid from the system and rebooting fixed the problem.

Why is dmraid doing anything at all when my motherboard doesn't support FakeRAID?  It seems that it is arbitrarily picking some set of drives to tie up, effectively disabling mdadm for some arrays. Nice.

Jim

