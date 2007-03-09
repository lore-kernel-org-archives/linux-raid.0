From: Neil Brown <neilb@suse.de>
Subject: Re: Changing partition types safe? raidtools to mdadm migration
Date: Fri, 9 Mar 2007 19:20:37 +1100
Message-ID: <17905.6357.483367.649579@notabene.brown>
References: <40b437200703082239s3d54df30n3b0f542f03770ad7@mail.gmail.com>
	<17905.1664.655065.164818@notabene.brown>
	<40b437200703082320t8daee7bp3ae3883b978e9cc9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Simon Matthews on Thursday March 8
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 8, simon.d.matthews@gmail.com wrote:
> 
> So I should be safe in just removing the raidtools package and
> installing mdadm?
> 

Possibly.
A significant difference is the way arrays are assembled at boot time.
raidtools depended on raidstart (which never worked reliably and
doesn't work at all with recent kernels) or type-FD partitions, 
which I assume you weren't using.

mdadm has a lot more flexibility.  You can still use type-FD
partitions if you want, or you create /etc/mdadm.conf with roughly the
output of 
   mdadm -Ds

though it is worth understanding the contents of that file and making
sure it is what you want.

NeilBrown
