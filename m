From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: tests/03r5assemV1 issues
Date: Tue, 03 Jul 2012 18:07:02 +0200
Message-ID: <wrfjpq8c96c9.fsf@redhat.com>
References: <wrfjtxxqcn38.fsf@redhat.com>
	<20120703114459.29c21b8f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120703114459.29c21b8f@notabene.brown> (NeilBrown's message of
	"Tue, 3 Jul 2012 11:44:59 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Mon, 02 Jul 2012 15:24:43 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>
>> Hi Neil,
>> 
>> I am trying to get the test suite stable on RHEL, but I see a lot of
>> failures in 03r5assemV1, in particular between these two cases:
>> 
>> mdadm -A $md1 -u $uuid $devlist
>> check state U_U
>> eval $tst
>> 
>> mdadm -A $md1 --name=one $devlist
>> check state U_U
>> check spares 1
>> eval $tst
>> 
>> I have tested it with the latest upstream kernel as well and see the
>> same problems. I suspect it is simply the box that is too fast, ending
>> up with the raid check completing inbetween the two test cases?
>> 
>> Are you seeing the same thing there? I tried playing with the max speed
>> variable but it doesn't really seem to make any difference.
>> 
>> Any ideas for what we can be done to make this case more resilient to
>> false positives? I guess one option would be to re-create the array
>> inbetween each test?
>
> Maybe it really is a bug?
> The test harness set the resync speed to be very slow.  A fast box will get
> through the test more quickly and be more likely to see the array still
> syncing.
>
> I'll try to make time to look more closely.
> But I wouldn't discount the possibility that the second "mdadm -A" is
> short-circuiting the recovery somehow.

That could certainly explain what I am seeing. I noticed it doesn't
happen every single time in the same place (from memory), but it is
mostly in that spot in my case.

Even if I trimmed the max speed down to 50 it still happens.

Cheers,
Jes
