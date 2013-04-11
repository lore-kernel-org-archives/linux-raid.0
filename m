From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Question about resync_mismatches
Date: Thu, 11 Apr 2013 14:21:24 -0500
Message-ID: <529903E0-4380-46E6-8171-FDB20BC13A4F@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

Neil,

Is the value of 'resync_mismatches' suppose to be random after the creation of an array and its completion of the initial resync?  Sometimes it is 0 and other times it is not.  I has the right value after a subsequent check is run, but I would think that it should be 0 after creation/init and before any check/repair.

 brassow

