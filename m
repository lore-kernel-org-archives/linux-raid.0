From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: Wed, 6 Aug 2003 11:01:23 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16176.21347.273135.576341@gargle.gargle.HOWL>
References: <3F2D1FAC.9030905@shaolinmicro.com>
	<16173.43804.617586.906225@gargle.gargle.HOWL>
	<3F2E8CAE.7090208@shaolinmicro.com>
	<16175.4992.765886.291774@gargle.gargle.HOWL>
	<3F2F4F7F.6010801@shaolinmicro.com>
	<16175.21583.621336.653083@gargle.gargle.HOWL>
	<3F2F9BEF.7080104@shaolinmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Chow on Tuesday August 5
To: David Chow <davidchow@shaolinmicro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 5, davidchow@shaolinmicro.com wrote:
> The point is my root is on  md2 . I can never reassemble the RAID 
> devices. This is just the same of using a --force with mkraid of mdadm 
> with reassemble . There seems no other way to update buggy superblocks 
> online or even do something with reboot? Can I just modify the field and 
> reset the machine after a "sync"?

You could try, but I wouldn't recommend it.

You could upgrade to 2.6 which it probably get it right, but as it is
still -testing, you might not want to.

Best solution is to boot a rescue disk and do it from there.

Sorry I cannot be more helpful.

NeilBrown
