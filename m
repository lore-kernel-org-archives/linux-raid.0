From: <me@heyjay.com>
Subject: Deleting an raid device
Date: Tue, 25 May 2004 07:54:38 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002501c44257$7135dd80$6705a8c0@a30>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

What are the proper steps for deleting all remnants of a previous raid
install?

I've done:
mdadm --stop /dev/md0
mdadm --zero-superblock /dev/md0

But I still see it getting stopped on shutdown.

Thanks
Jay

