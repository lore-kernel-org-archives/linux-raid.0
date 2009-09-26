From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID1 assembled broken array
Date: Sat, 26 Sep 2009 14:01:00 +0100
Message-ID: <4ABE108C.9030606@anonymous.org.uk>
References: <h8ophd$n8p$6@ger.gmane.org> <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com> <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name> <20090917082528.GO5174@skl-net.de> <19132.31575.349988.442763@notabene.brown> <20090926095834.GP5174@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090926095834.GP5174@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/09/2009 10:58, Andre Noll wrote:
> On 18:12, Neil Brown wrote:
>>> BTW: Why are new arrays still created with 0.90 metadata format by
>>> default?
>> Because I'm a chicken....
>>
>> I guess it probably is time ... but to we make the default 1.0, which
>> is compatible with people's expectations, to 1.1 which is generally a
>> safer approach (you cannot mount a bare device by mistake).
> 
> People will soon have to use 1.x anyway as drives are getting bigger
> than 2T. I'd vote for making 1.1 or 1.2 metadata the default for the
> reasons Doug pointed out. Failing to mount the bare device if there
> is a partition table is IMHO more important than meeting (broken)
> expectations.
> 
> Maybe we should depricate kernel-level autodetection at the same time
> so that using an initramfs becomes mandatory for setups with / on md.

It already is deprecated; afaik all the recent distros already use an 
initramfs, even if they still use 0.90 metadata.

I second making this a priority to get into the next round of distro 
updates, for all the reasons given. As soon as metadata version upgrade 
facilities go in to mdadm, 0.90 metadata can also be deprecated and 
perhaps mdadm can issue warnings, or at least the kernel autoassembly 
code can start issuing warnings (if it doesn't already).

Cheers,

John.
