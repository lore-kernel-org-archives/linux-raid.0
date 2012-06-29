From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Fri, 29 Jun 2012 10:18:30 +0200
Message-ID: <4FED64D6.9060305@xunil.at>
References: <4FE9BFC1.5070607@xunil.at> <20120628163205.2c6a1122@notabene.brown> <4FEC1CE7.5010709@xunil.at> <4FEC2071.8010504@xunil.at> <20120628212257.5ca8fb05@notabene.brown> <4FEC7EB7.1000401@xunil.at> <4FECA1A8.7090608@xunil.at> <20120629073632.61f529a8@notabene.brown>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120629073632.61f529a8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 28.06.2012 23:36, schrieb NeilBrown:
> On Thu, 28 Jun 2012 20:25:44 +0200 "Stefan G. Weichinger" 
> <lists@xunil.at> wrote:
>> What is the logic behind that?
> 
> As you have guessed, it first recovered one device, then recovered 
> the second one. But it looks like there are no read errors on the
> two good devices, so fear-not.

Good to know.

>> What does it do exactly when it re-adds the first disk, what in 
>> the second round?
>> 
>> Should I have added sd[ab]3 in one command?
> 
> Had you done that with a very new mdadm, it would have recovered
> both at once. mdadm has to say: - disable recovery for now - here
> is one new spare - here is another spare - ok, you can try recovery
> now
> 
> otherwise as soon as it gets one spare it will start recovery.

Thanks for the explanation.

>> To me it also seems that I now have good redundancy again
>> already, correct?
> 
> Correct.  You have single redundancy and in about 10 hours since
> your email you'll have double redundancy.

It is still rebuilding, must have been slowed down by some processes
using the filesystem at night. But still working.
