From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: New mailing list for 2.6 Medley RAID (Silicon Image 3112 etc.)
 BIOS RAID development
Date: Tue, 10 Feb 2004 09:39:10 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16424.3086.469482.77925@notabene.cse.unsw.edu.au>
References: <20040209121144.GA24503@devserv.devel.redhat.com>
	<Pine.LNX.4.40.0402091220130.8715-100000@jehova.dsm.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas Horsten on Monday February 9
To: Thomas Horsten <thomas@horsten.com>
Cc: Arjan van de Ven <arjanv@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 9, thomas@horsten.com wrote:
> The only thing I don't like about this solution is that we are relying on
> both the md and dm framework. I can't see an easy way around this, since
> we need to parse the partition table on the RAID. If we just create a
> separate md device for each partition, the user won't be able to change
> the partition table.

2.6.3-rc1-mm1 supports partitioning of md arrays though a new major
number.  I'm hopeful that this will get into 2.6.4 at least.

NeilBrown
