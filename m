From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Small short question Was: Re: Recovering from the kernel bug, Neil?
Date: Thu, 20 Sep 2012 11:49:07 -0600
Message-ID: <18C5DA72-E9B2-4657-B5B6-8B3EAB99E9C2@colorremedies.com>
References: <5030F07F.7000303@schinagl.nl> <504CFA7B.7090606@schinagl.nl> <20120910090829.19100cdf@notabene.brown> <504DA85C.6080000@schinagl.nl> <20120911161622.0b0fcf8c@notabene.brown> <505301E1.10707@schinagl.nl> <50531A52.7060205@schinagl.nl> <20120920122218.07f89443@notabene.brown> <505B4CDD.7010509@schinagl.nl>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505B4CDD.7010509@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 20, 2012, at 11:05 AM, Oliver Schinagl wrote:

>> 
> I did check the FS, I ran some fsck tests and checked data on the drive, everything appeared to be normal. I still have to verify some unimportant iso images, once that is done, I cannot imagine the data being bad.

You should make sure it wasn't just a quick journal check, which is now common. If the journal is clean, the file system is assumed to be clean, because that's faster than fully checking the file system. For e2fsck this means passing -f. You might want to use the -n option also.

For XFS you'd xfs_check first, and then xfs_repair -n which could take quite a while depending on the size of the file system.


Chris Murphy