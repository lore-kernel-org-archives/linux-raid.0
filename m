From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: RE: Alternative to RAID... No change to Data HDDs, only one simple
 "modulo"-Disk
Date: Mon, 21 Jun 2004 09:22:41 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0406210916400.4059-100000@coffee.psychology.mcmaster.ca>
References: <200406182019.i5IKJe327151@watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200406182019.i5IKJe327151@watkins-home.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> How do we read about this?

afaikt, he's just looking for an incremental raid system,
which is understandably attractive.  keeping track of which 
blocks are on N disks and which have been migrated to N+1
might be tricky, though.  certainly not impossible.

I often wonder whether it's sensible to consider putting 
raid-like reliability features into the filesystem, rather than
restricting ourselves to block-level raid...

