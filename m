From: "John Stoffel" <john@stoffel.org>
Subject: Re: zeroing old superblocks & upgrading...
Date: Fri, 7 Jul 2006 09:10:34 -0400
Message-ID: <17582.23882.797049.201350@stoffel.org>
References: <17581.36135.379062.709693@stoffel.org>
	<17581.38932.532010.388731@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17581.38932.532010.388731@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: John Stoffel <john@stoffel.org>, Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

>> I can't seem to zero it out:
>> 
>> # mdadm --misc --zero-superblock /dev/hde
>> mdadm: Couldn't open /dev/hde for write - not zeroing
>> 
>> Should I just ignore this, or should I break off /dev/hde from the
>> array and scrub the disk and then re-add it back in?

Neil> You could ignore it - it shouldn't hurt.

Ok.

Neil> But if you wanted to (and were running a fairly recent kernel) you
Neil> could
Neil>   mdadm --grow --bitmap=internal /dev/md0

Did this.  And now I can do mdadm -X /dev/hde1 to examine the bitmap,
but I think this totally blows.  To create a bitmap, I add it to an
md# device, but to examine it, I have to know which sub-devices to
query?  That's really not what I would expect.

I do see that 

	mdadm -q --detail /dev/md0

shows the bitmap status (though not the size or parameters of the
bitmap), which is good. 

Neil>   mdadm /dev/md0 --fail /dev/hde1 --remove /dev/hde1
Neil>   mdadm --zero-superblock /dev/hde
Neil>   mdadm /dev/md0 --add /dev/hde1

Worked wonderfully!  Cleaned out the old superblock nicely, which I
think is a good thing here. 

Neil>   mdadm --grow --bitmap=none /dev/md0

Neil> and it should work with minimal resync...

So why would I want to remove the bitmap?  The re-sync happened pretty
much quickly enough that I didn't even see any non-in-sync status when
I did the --add of the device back in.  Very very cool...

Though... if I was paranoid, I'd disable the bitmap because there's no
way to be sure that I didn't write some garbage at a random block N
somewhere in the array.  Hmm... can't make that guarrentee now either,
so it's probably a moot point.  

In any case, I'm planning on keeping the bitmap.  

Neil> Though thinking about it - after the first --grow, check that
Neil> the unwanted bitmap is still there.  It is quite possible that
Neil> the internal bitmap will over-write the unwanted superblock
Neil> (depending on the exact size and aligment of hde1 compared with
Neil> hde).  If it is gone, then don't bother with the rest of the
Neil> sequence.

It was still there after the addition of the bitmap.  

Thanks Neil!

John
