From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: strange RAID5 problem
Date: Tue, 09 May 2006 16:19:22 -0600
Message-ID: <4461156A.3050903@harddata.com>
References: <4460290C.50202@harddata.com> <20060509055824.GB22085@percy.comedia.it> <4460C059.3070304@harddata.com> <20060509192053.GA27247@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060509192053.GA27247@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Luca Berra wrote:
> ..
>>> I don't believe you, prove it (/proc/partitions)
>>>
>> I understand. Here we go then. Devices in question bracketed with "**":
>>
> ok, now i do.
> is the /dev/sdw1 device file correctly created?
> you could try straceing mdadm to see what happens
>
> what about the other suggestion? trying to stop the array and restart
> it, since it is marked as inactive.
> L.
>
Here is what we ended up doing that fixed it.
Thanks to Neil on the --force, however even with that,
ALL parameters were needed on the mdadm -C or it still refused.
We used EVMS  to rebuild as that is what originally created the RAID.

mdadm -C /dev/md3 --chunk=256 --level=5 --parity=ls --raid-devices=16
--force /dev/evms/.nodes/sdq1 /dev/evms/.nodes/sdr1
/dev/evms/.nodes/sds1 /dev/evms/.nodes/sdt1 /dev/evms/.nodes/sdu1
/dev/evms/.nodes/sdv1 missing /dev/evms/.nodes/sdx1
/dev/evms/.nodes/sdy1 /dev/evms/.nodes/sdz1 /dev/evms/.nodes/sdaa1
/dev/evms/.nodes/sdab1 /dev/evms/.nodes/sdac1 /dev/evms/.nodes/sdad1
/dev/evms/.nodes/sdae1 /dev/evms/.nodes/sdaf1

Notice we are assembling a device with a "missing" member, and the
devices are in "order" per: mdamd -D /dev/md3

This was the *only* that it would come up. It was mountable, data seems
intact.
We started the rebuild with no errors by simply adding the device
as I mentioned before with -a.

Then sped it up via:

echo "100000" > /proc/sys/dev/raid/speed_limit_min

Because frankly we have the resources to do so and need it going as fast
as possible.

-- 

Regards,
	Maurice

