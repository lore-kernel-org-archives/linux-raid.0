From: Helge Hafting <helgehaf@aitel.hist.no>
Subject: Re: Fw: [PATCH] md -  Zero out some kmalloced space in md driver
Date: Wed, 11 Jun 2003 11:48:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE6FAEC.1000705@aitel.hist.no>
References: <20030610213500.1fffb360.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@digeo.com>, neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> This should fix most (all??) of the recently reported problems with MD in
> 2.5.70-bk and derivatives.

This worked!
2.5.70-mm7 with raid-1 booted with no raid problems at all.
Great work!

Helge Hafting


