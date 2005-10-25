From: "John Stoffel" <john@stoffel.org>
Subject: Re: split RAID1 during backups?
Date: Tue, 25 Oct 2005 13:51:01 -0400
Message-ID: <17246.28805.267226.810872@smtp.charter.net>
References: <E1EUFcV-0005s3-00@toko.jab.org>
	<435DEE69.8030605@naa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <435DEE69.8030605@naa.net>
Sender: linux-raid-owner@vger.kernel.org
To: schmidt@naa.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Norman> What you should be able to do with software raid1 is the
Norman> following: Stop the raid, mount both underlying devices
Norman> instead of the raid device, but of course READ ONLY. Both
Norman> contain the complete data and filesystem, and in addition to
Norman> that the md superblock at the end. Both should be identical
Norman> copies of that.  Thus, you do not have to resync
Norman> afterwards. You then can backup the one disk while serving the
Norman> web server from the other. When you are done, unmount,
Norman> assemble the raid, mount it and go on.

Umm... so what you're proposing would mean that he would have to stop
his application, make sure nothing is accessing that volume, and then
restart the application?  

Somehow I don't see that happening.  

Why do you feel that you have to stop and umount the volume for the
splitting off of a read-only mirror pair for backups?  

John
