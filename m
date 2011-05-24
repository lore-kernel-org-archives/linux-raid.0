From: Jonathan Brassow <jbrassow@f14.redhat.com>
Subject: [PATCH 0 of 9] MD:  Updates for dm-raid.c support
Date: Mon, 23 May 2011 22:05:47 -0500
Message-ID: <201105240305.p4O35l5O029146@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

The following set of 9 patches is composed of three sets:
1) Patches 1-6 are small updates and fixes to what is already in the kernel.
2) Patch 7 introduces a new superblock type for device-mapper - allowing it
to record failures and give future support for reshaping and bitmap use.
3) Patches 8-9 provide bitmap support.  Patch 9 is necessary for transient failures,
where the bitmap can be replayed to recover a disk that has been gone for a short
time.  Without patch 9, raid5 will simply force a complete resync.

The first set by itself fixes a couple issues and protects against the      
possibility that dm-raid.c attempts to utilize super_types that may not exist.
The addition of the second set provides a working solution that is useful to
LVM in addition to (userspace) dm-raid.  The final set is not absolutely   
necessary, but provides the obvious recovery speed-up.

I have seen an issue related to the MD recovery thread starting up before the
bitmap has been properly loaded.  This issue is not a result of this patchset,
nor is it addressed by this patch set.  Until I find a way to fix this issue,
the 3rd set may be problematic and we may wish to defer it until I have a 
solution.

 brassow

