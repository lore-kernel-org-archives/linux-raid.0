From: Neil Brown <neilb@suse.de>
Subject: Re: parity check for read?
Date: Wed, 4 Apr 2007 07:07:53 +1000
Message-ID: <17938.49705.840745.66635@notabene.brown>
References: <461254DF.3050503@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mirko Benz on Tuesday April 3
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday April 3, mirko.benz@web.de wrote:
> Hi,
> 
> Is parity calculation and validation for read operations supported?

I guess what you are asking is:

   With raid5, I would like the drive to handle a read request by
   reading all the blocks in the stripe and checking the parity.  If
   the parity is correct, return the data blocks.  If it is not, then
   fail the read request.  Is that possible?

No, it is not.

If you are really asking something else, please be more specific.

NeilBrown
