From: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Subject: Re: multiple disk failures in an md raid6 array
Date: Thu, 11 Apr 2013 20:48:42 +0000
Message-ID: <CD8C97E6.4113A%michael.vanhorn@wright.edu>
References: <51671EC0.9000707@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51671EC0.9000707@turmel.org>
Content-Language: en-US
Content-ID: <262146580FCE9949AE758027EE4DC67E@prod.exchangelabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Mike VanHorn <mr_vanhorn@yahoo.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>
>>
>>
>>Also, Microsoft's mail server from whence my message was
>> originating has been blacklisted on your server, so I am
>> sending this to you from my personal account on Yahoo!.
>
>You really need to fix your server, then, or just use this yahoo
>account for linux-raid.  My server just uses standard SPF validation
>and common dns blacklists.

Well, I have no control over that, as the University is a Microsoft
customer, but it appears it's been cleared up now because things are going
through again.

>Are you already doing weekly scrubs and drive self-tests?

Yes. I have it do a scrub by writing "check" to
/sys/block/md0/md/sync_action from cron.weekly, and I have a weekly script
that runs smart tests, too.

>Do you still have the complete dmesg from the original triple
>failure?

Unfortunately, no. I thought I kept it, but I have either misplaced the
file or just didn't do it like I thought I did.

There has been a reboot since the failure, and sde has magically come back
and seems to be okay, so the only "bad" disk is actually sdj, which was
the space.  However, see my other thread about "Odd --examine output" for
more info; I haven't been able to reassemble the array (and I should have
enough disks) because the metadata doesn't seem to be in the right place.
On /dev/sd[cdefi], there is one set of metadata (from what I believe was
an earlier rendition of the array, such that this data is now invalid) and
on /dev/sd[gh]1, there is a newer set of metadata, the dates for which
correspond with when this array was created. So, I'm thinking that the
metadata is actually on /dev/sd[cdefi]1, but I can't get to it because
those devices don't exist (such that I can't run, for example, mdadm -E
/dev/sdc1, because /dev/sdc1 doesn't exist).

As I stated in the other thread, I am very confused.

---
Mike VanHorn
Senior Computer Systems Administrator
College of Engineering and Computer Science
Wright State University
265 Russ Engineering Center
937-775-5157
michael.vanhorn@wright.edu
http://www.cecs.wright.edu/~mvanhorn/




