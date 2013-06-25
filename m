From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: Preparing for mdadm-3.3
Date: Tue, 25 Jun 2013 10:40:20 +0200
Message-ID: <wrfjobaueg7f.fsf@redhat.com>
References: <20130624171818.71a9688a@notabene.brown>
	<wrfjli5zfq1c.fsf@redhat.com> <20130625094211.20134bed@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130625094211.20134bed@notabene.brown> (NeilBrown's message of
	"Tue, 25 Jun 2013 09:42:11 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Mon, 24 Jun 2013 18:10:23 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>
>> NeilBrown <neilb@suse.de> writes:
>> > Hi all,
>> >  it has been way too long since an mdadm release.  So I'm hoping to pull one
>> >  together over the next few weeks.  It will be mdadm-3.3
>> >  My goal is to have it out by 25th July (i.e. one month).
>> 
>> Hi Neil,
>> 
>> I don't see any mention of hot replace support in your log. Did this get
>> canned or did I just lose track of everything? Admittedly my marbles
>> have gotten lost regularly the last couple of months.
>> 
>
> Hi Jes,
>  yes, hot replace support is something I should have mentioned but didn't
>
>    mdadm /dev/md0 --replace /dev/foo
>
>  will try to replace /dev/foo with a spare.
>
>    mdadm /dev/md0 --replace /dev/foo --with /dev/bar
>
>  will try to replace it with the spare "/dev/bar".
>
>  Testing of that would be good too.
>  I'll be sure to mention that in the 3.3 announcement.  Thanks.

Great, I'll try and package up mdadm-3.3-rc1 and see if I can get QA on
my end to test it.

Cheers,
Jes
