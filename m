From: "NeilBrown" <neilb@suse.de>
Subject: Re: "mdadm --remove" fails if it is too soon after "mdadm --fail"
Date: Thu, 15 Oct 2009 12:49:12 +1100
Message-ID: <eebda61d9dea7affc2934fd8d887b752.squirrel@neil.brown.name>
References: <alpine.DEB.1.00.0910131748110.8815@darius>
    <alpine.DEB.1.00.0910141236260.14710@darius>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0910141236260.14710@darius>
Sender: linux-raid-owner@vger.kernel.org
To: "Darius S. Naqvi" <dnaqvi@datagardens.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, October 15, 2009 5:38 am, Darius S. Naqvi wrote:
> On Wed, 14 Oct 2009, Darius S. Naqvi wrote:
>
>> I.e., it seems that the ioctl invoked by --fail doesn't directly set
>> up the device to be ready for --remove, but some other kernel thread
>> completes that state change.  I'm wondering if it could be the case
>> that when the system is very, very busy, it could take long enough for
>> that kernel thread to run that it would cause what I see, i.e.,
>> --remove fails with EBUSY, even though I've already waited about 20
>> seconds for the device to be ready to be removed.  If this is so, what
>> shall I do?  Here are the options I can think of:
>
> Sorry to reply to my own posting.  It turns out that in this case,
> I've only waited 2.5 seconds.  This may affect the probability of my
> hunch being correct.

2.5 seconds certainly seems more believable than 20 seconds.
Waiting for the kernel thread to run is not the only cause for delay.
If there are any pending IO requests, you have to wait for all of those
to complete before the device can be removed from the array.
As error handling can take an arbitrarily long time, there can be
an arbitrary delay between a device being marked faulty and it being
able to be removed from the array.

So probably the best bet is simply to wait and retry as you are doing.
If I were to make it more deterministic, I would probably allow you to
'poll' or 'select' on the sysfs file /sys/block/mdX/md/dev-YYY/slot
and once that becomes 'none', the device can be removed.

NeilBrown


>
> --
> Darius S. Naqvi
> dnaqvi@datagardens.com
> http://www.datagardens.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

