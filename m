From: "Colin McDonald" <ce.mcdonald@gmail.com>
Subject: RHEL3 kernel panic with md
Date: Fri, 7 Apr 2006 17:47:35 -0400
Message-ID: <bbfa52890604071447t2e791afai781522f9f204485d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I appear to have a corrupt file system and now it is mirrored. LOL.

I am running Redhat Enterprise 3 and using mdtools.

I booted from the install media iso and went into rescue mode. RH was
unable to find the partitions automatically but after exiting into
bash i can run fdisk -l and i see all of the partitions.

I know this is sparse info but would any of the group be able to give
the best approach to getting them  mounted and fsck'd?

Thank you in advance

Colin
