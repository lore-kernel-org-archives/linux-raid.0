From: "Kenn" <kenn@kenn.us>
Subject: Re:
Date: Mon, 26 Sep 2011 16:23:17 -0700
Message-ID: <f4da446ee714e17899d9657c8a4da9f2.squirrel@www.maxstr.com>
References: <09f356fa46129bd08dd45752c0f736de.squirrel@www.maxstr.com>
    <20110926145248.6ffc5f02@notabene.brown>
    <20110926130351.63adc330@natsu>
Reply-To: kenn@kenn.us
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110926130351.63adc330@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, rm@romanrm.ru
List-Id: linux-raid.ids

> On Mon, 26 Sep 2011 14:52:48 +1000
> NeilBrown <neilb@suse.de> wrote:
>
>> On Sun, 25 Sep 2011 21:23:31 -0700 "Kenn" <kenn@kenn.us> wrote:
>>
>> > I have a raid5 array that had a drive drop out, and resilvered the
>> wrong
>> > drive when I put it back in, corrupting and destroying the raid.  I
>> > stopped the array at less than 1% resilvering and I'm in the process
>> of
>> > making a dd-copy of the drive to recover the files.
>>
>> I don't know what you mean by "resilvered".
>
> At first I thought the initial poster just invented some peculiar funny
> word of his own, but it looks like it's from the ZFS circles:
> https://encrypted.google.com/search?q=resilver+zfs
> @Kenn; you probably mean 'resync' or 'rebuild', but no one ever calls
> those processes 'resilver' here, you'll get no google results and
> blank/unknowing/funny looks from people when using that term in relation
> to mdadm.

Good point, I am a very old unix user and my RAID terminology hasn't been
properly updated since college.  Resilver is mentioned here in wikipedia
for disk mirroring http://en.wikipedia.org/wiki/Disk_mirroring and I've
always used the word but it's not in the RAID page and I'll switch to
"rebuilding".

Thanks,
Kenn


>
> --
> With respect,
> Roman
>


