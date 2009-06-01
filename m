From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Awful RAID5 random read performance
Date: Mon, 01 Jun 2009 13:41:52 +0200
Message-ID: <87tz30qiyn.fsf@frosties.localdomain>
References: <20090601045710141.GMHE24335@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090601045710141.GMHE24335@cdptpa-omta04.mail.rr.com> (Leslie
	Rhorer's message of "Sun, 31 May 2009 23:57:04 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Leslie Rhorer" <lrhorer@satx.rr.com> writes:

>>  >	John is perfectly correct, although of course a 10ms seek is a
>>  >fairly slow one.
>> 
>> Unfortunately it doesn't seem to be. Take a well-considered drive such
>> as the WD RE3; it's spec for average latency is 4.2ms. However does it
>> include the rotational latency (the time the head takes to reach the
>> sector once it's on the track)? I bet it doesn't. Taking it to be only
>> the average seek time, this drive is still among the fastest. For a
>> 7200rpm drive this latency is just 4.2ms, so we'd have for this fast
>> drive an average total latency of 8.4ms.
>
> That's an average.  For a random seek to exceed that, it's going to have to
> span many cylinders.  Give the container size of a modern cylinder, that's a
> pretty big jump.  Single applications will tend to have their data lumped
> somewhat together on the drive.

Only at the start, which is usualy when people benchmark. But after a
while filesystem fragment. Files get distributed all over the disk,
files themself get spread out as they grow. And suddenly an FS that
was fine  month ago is too slow.

The worst you can do to an FS is run mldonkey/rtorrent on it with lots
of downloads. I've managed to get an ext2 to the point where copying a
file from the FS to another disk only managed <100kiB/s.

In conclusion: Seek times can not be ignored and they should be
avoided.

MfG
        Goswin
