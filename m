From: Mark Knecht <markknecht@gmail.com>
Subject: Automate on-going checks?
Date: Wed, 16 Feb 2011 11:05:41 -0800
Message-ID: <AANLkTikpe3vShQXcMKFW5qK3ZuzaKqnotB29vciyFUEj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I'm setting up a new laptop that my dad bought as a present for my
mom. One interesting aspect of this laptop is that it has two 500GB
hard drives in it so I was going to use RAID1. As the laptop will be
at a location that I won't often visit I wanted to set up some sort of
on-going daily/weekly testing of the RAID that the machine could email
the results to me.

Is there a document somewhere that goes over what mdadm (or other
tools) provide in this area? I assume I'll use smartctl as part of the
solution but what else can I do to reduce the chances of something
getting overlooked?

Thanks,
Mark
