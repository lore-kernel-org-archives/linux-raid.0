From: Danilo Godec <danci@agenda.si>
Subject: e2fsck, badblocks - a bit OT
Date: Wed, 10 Apr 2002 08:55:28 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0204100851060.20718-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just have a tiny question about e2fsck and badblocks - if the filesystem
is already populated and I issue the command 'e2fsck -c ...', will those
bad blocks get marked as such? Will the filesystem stop using them?


Thanks, D.

