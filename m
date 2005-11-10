From: Neil Brown <neilb@suse.de>
Subject: Re: how to understand this bitmap_zero
Date: Thu, 10 Nov 2005 13:20:24 +1100
Message-ID: <17266.44648.898983.301245@cse.unsw.edu.au>
References: <1131557337.8969.466.camel@localhost.localdomain>
	<17266.30795.161044.844874@cse.unsw.edu.au>
	<1131577875.452.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ming Zhang on Wednesday November 9
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 9, mingz@ele.uri.edu wrote:
> ic. thx!
> 
> so it seems that we still have to use set_bit in a for loop to set
> certain particular area, rite?

Correct.

NeilBrown
