From: Neil Brown <neilb@suse.de>
Subject: Re: Problem with mdadm 2.6.7
Date: Tue, 29 Jul 2008 10:59:33 +1000
Message-ID: <18574.27509.370113.998930@notabene.brown>
References: <488C531B.5060005@mandriva.org>
	<488C8599.4090503@mandriva.org>
	<1217171198.9041.62.camel@firewall.xsintricity.com>
	<488C9328.8010503@mandriva.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas Backlund on Sunday July 27
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Backlund <tmb@mandriva.org>
Cc: Doug Ledford <dledford@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday July 27, tmb@mandriva.org wrote:
> 
> as for --bitmap, can it be added to an existing array ?

Yes.
> 
> What is the better choice, bitmap=internal or bitmap=<some_file> ?

Internal is easier.

The command is
   mdadm --grow /dev/mdXXX --bitmap=internal

This could have a negative impact on performance.  The degree depends
a lot on your workload.
If you notice a reduction in write speed that is not acceptable, and
if removing the bitmap (mdadm --grow /dev/mdXXX --bitmap=none) fixes
the problem, then we can try to find an alternate solution.

> 
> I'd hate to have to recreate the array, as I have about 1.2GB of data on 
> it...

There is no need for that.

NeilBrown

