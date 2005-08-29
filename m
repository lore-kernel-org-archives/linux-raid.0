From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: RAID-5 Expansion
Date: Mon, 29 Aug 2005 16:32:41 -0500
Message-ID: <1125351161.7159.5.camel@langvan2.homenetwork>
References: <b53b67d205082913057e3bacd3@mail.gmail.com>
	 <005901c5acd5$fff03130$bd00a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <005901c5acd5$fff03130$bd00a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2005-08-29 at 15:12, David M. Strang wrote:
> EMVS supports this --
> 
> http://evms.sourceforge.net
> 
> However, in my experience -- it's really slow; and it was faster for me to 
> backup the data to tape; recreate the raid and restore.
> 
> It may be faster now; that was under release v2.5.1
> 
> David M. Strang
> 

With current evms, raid5 resize is still slow, sorry :(.  Improving I/O
performance during resize is in my to-do list.

--
Regards,
Mike T.


