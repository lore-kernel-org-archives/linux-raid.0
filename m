From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: can you help explain some --examine output to me?
Date: Fri, 19 Dec 2008 19:25:46 -0600
Message-ID: <cccedfc60812191725h643e512ewa95248fc0852244f@mail.gmail.com>
References: <cccedfc60812191634s74d77322pae0def691388c36e@mail.gmail.com>
	 <05e7e5a941b9af88462a85af4d4efc33.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05e7e5a941b9af88462a85af4d4efc33.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 19, 2008 at 7:16 PM, NeilBrown <neilb@suse.de> wrote:
> On Sat, December 20, 2008 11:34 am, Jon Nelson wrote:
>> As part of the output from --explain (on a raid1 with a 1.0 metadata),
>> I see this:
>>
>>     Array Slot : 3 (failed, failed, 0, 1)
>>    Array State : uU 2 failed
>>
>> I read the first line as "This device is using slot 3. slot 0 is
>> failed, slot 1 is failed, slot 2 is RaidDevice 0, slot 3 is RaidDevice
>> 1" where RaidDevice is the same as in the output for --detail. Is that
>> correct?
>>
>> The second line is more opaque. What to little-u and big-u mean? Does
>> "2 failed" mean the raid thinks two devices have failed?
>>
>
> Yes, it is rather cryptic...
>
> Every device in a 1.x array is assigned a 'slot' number.  This number is
> stable - it never changes.
>
> Each device in the array also has a 'role' number indicating its current
> role in the array, which is either to be a spare or to have a position
> (0, 1, ...) in the array.
>
> The output you produces says that this device occupies slot 3.
> It then notes that:
>  the device which occupied slot 0 has failed
>  the device which occupied slot 1 has failed
>  the device which occupies slot 2 has role 0
>  the device which occupies slot 3 has role 1
>
> Then it shows you the state which indicated how the different
> roles are going.
>   uU
> means that both roles are 'up', and the 'this' device has the second
> role (capital U for 'this' device).
> Two devices have previously failed.

Thanks, that's a great explanation.

> Note that if you fail a devices, remove it, then add it back in such that
> it doesn't appear to be a re-add, it will be treated like a new
> device and get a new slot number.  (after all the old device was faulty,
> this one isn't so it must be a new device ?).
> I should probably get it to re-use the slot number in that case.

-- 
Jon
