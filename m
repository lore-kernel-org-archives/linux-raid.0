From: Chris Webb <chris@arachsys.com>
Subject: Re: Trouble increasing md component size
Date: Fri, 20 Jun 2008 00:10:20 +0100
Message-ID: <20080619231020.GE3708@arachsys.com>
References: <20080618182622.GA29468@arachsys.com> <4859605D.90509@rabbit.us> <20080618200036.GB30682@arachsys.com> <18521.54665.166875.489547@notabene.brown> <20080619154520.GB3708@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080619154520.GB3708@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Webb <chris@arachsys.com> writes:

> I guess that ideally rdev_size_store should write out the changed rdev->size
> to the metadata when it's called on a running array, in a similar manner to
> size_store for component_size? If the superblock is version 1.x, I'm already
> updating the data_size in the superblock ready to write out:

(Also, once I get the superblock writing out okay, I can presumably support
metadata format 1.0 too, updating the sb_offset and writing a new copy at
the end of the disk.)

Cheers,

Chris.
