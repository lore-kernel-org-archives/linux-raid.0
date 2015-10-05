From: rgoldwyn@suse.de
Subject: [PATCH 0/5 v2] md-cluster: A better way for METADATA_UPDATED processing
Date: Mon,  5 Oct 2015 10:09:49 -0500
Message-ID: <1444057794-17256-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids


The processing of METADATA_UPDATED message is too simple and prone to
errors. Besides, it would not update the internal data structures as
required.

This set of patches reads the superblock from one of the device of the MD
and checks for changes in the in-memory data structures. If there is a change,
it performs the necessary actions to keep the internal data structures
as it would be in the primary node.

An example is if a devices turns faulty. The algorithm is:

1. The initiator node marks the device as faulty and updates the superblock
2. The initiator node sends METADATA_UPDATED with an advisory  device number to the rest of the nodes.
3. The receiving node on receiving the METADATA_UPDATED message
  3.1 Reads the superblock
  3.2 Detects a device has failed by comparing with memory structure
  3.3 Calls the necessary functions to record the failure and get the device out of the active array.
  3.4 Acknowledges the message.

The patch series also fixes adding the disk which was impacted because of
the changes.

Patches can also be found at
https://github.com/goldwynr/linux branch md-next

md-cluster.c |   56 +++++++++--
md-cluster.h |    1 
md.c         |  293 +++++++++++++++++++++++++++++++++++++++++------------------
md.h         |    2 
raid1.c      |    2 
5 files changed, 253 insertions(+), 101 deletions(-)



