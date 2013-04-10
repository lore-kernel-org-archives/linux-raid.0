From: NightStrike <nightstrike@gmail.com>
Subject: Re: mdadm + intel matrix
Date: Wed, 10 Apr 2013 01:48:36 -1000
Message-ID: <CAF1jjLurfkk2w49KcGUmg0yEUoJLtAh7KfGow3sm3nGQUg3jCg@mail.gmail.com>
References: <CAF1jjLtMKmvQrZqO9Uv5vW6VGSJ8OmJZ8G3QxNZ6oGXr-3kS_Q@mail.gmail.com>
 <20130410145359.4a864dcf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130410145359.4a864dcf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 9, 2013 at 6:53 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 9 Apr 2013 03:20:44 -1000 NightStrike <nightstrike@gmail.com> wrote:
>
>> Neil,
>>
>> I have been talking to a lot of irc types, and ultimately, they all
>> want me to just contact you directly (even people on
>> oftc/#kernelnewbies).
>
> The correct advice is to email linux-raid@vger.kernel.org (you don't need to
> be subscribed) and to optionally Cc me.
> I've Cc:ed this reply to linux-raid.

Noted

>> Basically, using mdadm with the Intel Matrix fakeraid doesn't work
>> right anymore.  I can't tell you with what kernel it stopped, but I
>> can tell you that it is broken with archlinux 3.8.5, which is a
>> vanilla kernel plus a console logging patch.  Here's what happens:
>>
>> 1) Create a new raid in the Option Rom
>> 2) Boot up and see md126 and md127, respectively ArchRaid_0 and imsm0.
>> 3) Run all sorts of read only things, like mdadm --detail-platform, all good
>> 4) Run cfdisk /dev/md/ArchRaid_0 (which points to md126), set up my partitions
>> 5) Hit "Write" to write the partition table
>> 6) Everything hangs
>
> I've had this reported on openSUSE too.  I haven't yet had a chance to look
> into it properly.
> It sounds like "mdmon" is not running - or not working correctly.
>
> On the first attempt to write to the array, md signals mdmon and waits for
> the array to be marked "active".
> mdmon should notice this, update the metadata on the array to record that the
> array is active (so if a crash happens a resync will be force) and then tell
> md that the array is active.  md notices and allows the write.
>
> Something in this sequence is not working.
> Does everything "unhang" if you run
>    mdmon md127 &
>
> ??

YES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

THANK YOU!!!!!!!!!!!!!!!11111oneone!!!!!!!!!!


I eagerly await an official fix, and in the meantime, I will use your
workaround.
