From: jbradford@dial.pipex.com
Subject: RAID backup
Date: Thu, 3 Oct 2002 12:20:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200210031120.g93BKLqK000216@darkstar.example.net>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: roy@karlsbakk.net
Cc: jakob@unthought.net, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Might it not be a good idea to DD the raw contents of each disk to a tape drive, just incase you fubar the array?  It would be time consuming, but at least you could restore your data in the event that it gets corrupted.

John.
