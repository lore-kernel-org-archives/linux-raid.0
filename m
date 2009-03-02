From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: MD software RAID1 vs suspend-to-disk
Date: Mon, 02 Mar 2009 13:23:11 +1100
Message-ID: <87ocwky86o.fsf@rimspace.net>
References: <87d4d17hgh.fsf@rimspace.net> <49AB2B65.6070102@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson <john.robinson@anonymous.org.uk> writes:
> On 01/03/2009 08:52, Daniel Pittman wrote:
>
>> I have a random desktop machine here, running Debian/sid with a 2.6.26
>> Debian kernel.  It has a two disk software RAID1, and apparently passes
>> through a suspend/resume cycle correctly, but...
>
> I'm not sure if this is the same suspend/resume - there are after all several
> Googleable reasons why one might suspend or resume various things - but it
> might be worth a look at NeilB's recent post of a patch to "hopefully enable
> suspend/resume of md devices":
> http://marc.info/?l=linux-raid&m=123440845819870&w=2

No, that appears to be about suspending and resuming access to the
MD device while reconfiguring it; I don't /think/ that is accessed
during a system-wide suspend/resume (aka hibernate, or s2disk) cycle.

Certainly, it doesn't look like the path is invoked for that from my
reading of the code.

Regards,
        Daniel

