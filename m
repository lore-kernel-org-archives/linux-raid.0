From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: Move md raid5 from intel to sparc?
Date: 11 Jun 2003 14:17:54 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1055359074.1929.70.camel@langvan.austin.ibm.com>
References: <3EE74472.9010505@geodev.com>
	 <1055350640.1929.28.camel@langvan.austin.ibm.com>
	 <3EE76EDA.1060000@geodev.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EE76EDA.1060000@geodev.com>
To: Matthew Mitchell <matthew@geodev.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2003-06-11 at 13:03, Matthew Mitchell wrote:

> What _about_ the filesystem and data, though?  Some filesystems are 
> certainly written in a known byte-order, like ISO 9660.  Are there any 
> of (ext3, XFS, JFS, reiserfs) that this is true for?  Or are they all 
> written in cpu native byte-order?

Just look at the current releases of kernel, 2.4 and 2.5, all of the
above filesytems seem to write metadata using one known byte-order (ei.
always BE or always LE).  Now all we need is testing.

-Mike Tran


