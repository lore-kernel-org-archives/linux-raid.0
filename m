From: Jeff Garzik <jeff@garzik.org>
Subject: Re: hdaprm -Y /dev/sda /dev/sdb -> I/O error -> disk kicked out of
      RAID - is it normal?
Date: Fri, 17 Jul 2009 01:20:03 -0400
Message-ID: <4A600A03.5040808@garzik.org>
References: <4A5FB1DD.3000904@wpkg.org> <4A5FFA46.1070203@kernel.org> <29d09dacb3dce47830a95bc6493d3b88.squirrel@neil.brown.name> <4A6002AC.9090807@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A6002AC.9090807@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: NeilBrown <neilb@suse.de>, Tomasz Chmielewski <mangoo@wpkg.org>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Tejun Heo wrote:
> NeilBrown wrote:
>> I tried that and easily found cases where it fails way too fast.
>> FAILFAST seems to mean different things on different devices, making
>> it useless in general (it is still useful in some specific cases
>> such as multipath on devices which are expected to be used under
>> multipath and so treat FAILFAST appropriately).
> 
> Yeap, FAILFAST flags seem geared pretty much toward multipathing.

Yes :/

I'm glad this area is getting some attention, because we ideally want to 
do two things in parallel:

* send upper layer advisory message, when we first notice a failure
* begin EH recovery

Time passes, libata attempts recovery, and completes the command with 
success or failure many seconds later.

Right now, failfast handling is inconsistent, and is not (I think...) 
always signalled as soon as we begin EH.

	Jeff


