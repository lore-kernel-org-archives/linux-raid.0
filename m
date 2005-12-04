From: Neil Brown <neilb@suse.de>
Subject: Re: Does mdadm --create harm existing data?
Date: Mon, 5 Dec 2005 08:54:17 +1100
Message-ID: <17299.25993.708991.834239@cse.unsw.edu.au>
References: <200512032330.jB3NUWX9017265@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Burgess on Saturday December 3
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday December 3, aab@cichlid.com wrote:
> In mail.linux.raid I write:
> 
> >Other than the superblocks, does 'mdadm --create' harm existing data?
> 
> It would seem not according to this test:

If resync starts (as it normally does with mdadm --create), and if you
assembled the array 'wrongly', then you could possibly corrupt data.
If you want to be cautious, always create the array degraded (with a
suitable number of 'missing' entries).  Then you can be sure that only
the superblocks will be changed.

NeilBrown
