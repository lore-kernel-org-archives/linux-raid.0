From: Wil Reichert <wil.reichert@gmail.com>
Subject: filesystem stripe parameters
Date: Thu, 18 Jun 2009 12:08:17 -0700
Message-ID: <7a329d910906181208t2f95d94bsc4eac2c5f20355f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When using LVM on top of RAID 5, is it still worthwhile to pass RAID
stripe information to the filesystem on creation?  Or do the PE's in
LVM blur the specific stripe sizes & I'd want to use some multiple of
those instead?

Wil
