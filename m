From: Digimer <lists@alteeve.ca>
Subject: Re: Broken array, trying to assemble enough to copy data off
Date: Thu, 10 Oct 2013 12:54:44 -0400
Message-ID: <5256DBD4.4030906@alteeve.ca>
References: <5255E5E4.8010900@alteeve.ca> <5255E98C.3020009@alteeve.ca> <5256A14B.7030008@turmel.org> <5256D3C4.5010109@alteeve.ca> <5256D773.2010808@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5256D773.2010808@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/13 12:36, Phil Turmel wrote:
> On 10/10/2013 12:20 PM, Digimer wrote:
>>> Phil
>>
>> Ya, I have no plan at all to use these drives or the server they came
>> from anymore. In fact, they've already been replaced. :)
> 
> That's good.
> 
>> I tried the --assemble --force (and --assemble --force --run) without
>> success. It fails saying that sde2 thinks sdb2 has failed, leaving two
>> dead members. If I try to start with just sd[bcd], it says that it has
>> two drives and one spare, so still refuses to start.
> 
> Ok.
> 
>> Any other options/ideas? I'm not in any rush, so I am happy to test things.
> 
> Well, you have rock-solid knowledge of the device order and array
> parameters.  So a --create operation is the next step.  Given that sdd2
> is marked as spare, and therefore of unknown value, I'd leave it out.
> 
> mdadm --stop /dev/md1
> mdadm --create --level=5 -n 4 --chunk=512 /dev/md1 \
> 	/dev/sd{c,e,b}2 missing
> 
> (--assume-clean isn't needed when creating a degraded raid5)
> 
> The brace syntax is needed, not brackets, as the order matters.
> 
> After creation, use mdadm -E to verify the Data Offset is 2048.  If not,
> get a new version of mdadm that lets you specify it.
> 
> Only after that should you use "fsck -n" to verify your filesystem and
> mount it.
> 
> HTH,
> 
> Phil

What if I don't have rock-solid knowledge? Is there a way to connect the
four drives and query them to determine which is which? I was using the
new system (minus the new drives) plus a spare new 500GB drive with the
fresh centos install to do the testing yesterday. I am pretty sure I can
redo the cabling to match, but I always prefer safe over sorry. :)

Thanks very much for your help so far!

digimer

-- 
Digimer
Papers and Projects: https://alteeve.ca/w/
What if the cure for cancer is trapped in the mind of a person without
access to education?
