From: "NeilBrown" <neilb@suse.de>
Subject: Re: 2 Disks Jumped Out While Reshaping RAID5
Date: Mon, 7 Sep 2009 10:31:32 +1000 (EST)
Message-ID: <3b8699b874ea2645458f9295812270a5.squirrel@neil.brown.name>
References: <70ed7c3e0909051322l7cf66158lbbc8a5dd2cc18b8b@mail.gmail.com>
    <a6dfa0829c75cc81fd4482bb344bbff2.squirrel@neil.brown.name>
    <70ed7c3e0909060300la51bec3ke51c35373b2ee1fc@mail.gmail.com>
    <19108.19281.495223.465327@notabene.brown>
    <70ed7c3e0909061655u344c2c6dt1939f85b10f49fa0@mail.gmail.com>
    <70ed7c3e0909061701i4190642ew66827a3aca3c277e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909061701i4190642ew66827a3aca3c277e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, September 7, 2009 10:01 am, Majed B. wrote:
> I have installed mdadm 3.0 and ran -Af and now it's continuing
> reshaping!!!

Excellent.

Based on the --examine info you provided it appears that
/dev/sdg1 reported an error at about 00:10:39 on Wednesday morning
and was evicted from the array.  Reshape was up to 2435GB (37%) at
that point.
Reshape continued until 06:40:04 that morning at which point it
had reached 3201GB (49%).  At that point /dev/sdf1 seems to have
reported an error so the whole array went off line.

When you reassembled with mdadm-3.0 and --force, it excluded sdg1
as that was the oldest, and marked sdf1 as up-to-date, and continued.

The reshape processes will have redone the last few chunks so all
the data will have been properly relocated.

As all the superblocks report that the array was "State : clean",
you can be quite sure that all your data is safe (if they were
"State : active" there would be a small chance some a block or two
was corrupted and a fsck etc would be advised).

It wouldn't hurt to examine your kernel logs to see what sort of
error was tiggered at those two times in case there might be a need
to replace a device.




> sdg1 is not in the list. Is that correct?!  sdg1 was one of the
> array's disks before expanding. So I guess now the array is degraded
> yet is reshaping as if it had 8 disks, correct?

Yes, that is correct.
It may be that sdg has a transient error, or it may have a serious
media or other error.  You should convince yourself that it is working
reliably before adding it back in to the array.



>
> So after the reshaping process is over, I can add sdg1 again and it
> will resync properly, right?

Yes it will, providing no write-errors occur while writing data to it.

NeilBrown

