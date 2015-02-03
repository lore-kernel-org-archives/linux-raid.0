From: Weedy <weedy2887@gmail.com>
Subject: Off-Topic Write cache disabling?
Date: Tue, 3 Feb 2015 12:45:44 -0500
Message-ID: <CAFE24U1G9+bqTzK4eD-cenyc5CGQQdrcu7S9Ks4CsHPS9wJ4zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there a kernel option or sysfs toggle that disables write caching?
Or forces the kernel to commit everything constantly.

------
I don't really want to join another ML, especially a higher traffic
one just to ask this when it only bugs me sometimes. But I'll shut up
if this is unwanted.
------

I use a similar kernel config with respect to selected options on all
my systems but this only effect my laptop.
On any of my personal system or system I have remote access too
nr_dirty drifts up and down and nr_writeback stays around 0 (assuming
the system isn't working hard).
On my laptop both nr_dirty and nr_writeback stay at 0. I can make them
go up to 10ish if I untar something but then almost immediately go
back to 0. If I didn't know better I would swear dirty_*_centisecs or
something was set to a near instant commit interval but I haven't
found evidence of that. The hard drive light blinks almost constantly
once a second, even if I'm at a X login screen.
As I said this doesn't bug me most of the time but if I let my FF
session get too large or start multiple VMs anything that might make
me swap a little, the machine pretty much dies from IOWAIT. Which I'm
guessing is because it's trying to flush (syncfs?) imediately and
constantly.

You guys spend all day in the IO subsystem, any idea where I can keep
looking? It has persisted across reboots and kernel updates.
