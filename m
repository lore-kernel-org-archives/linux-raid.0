From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Print correct md device name if write_init_super fails
Date: Wed, 22 Feb 2012 12:00:15 +0100
Message-ID: <4F44CABF.7070508@redhat.com>
References: <1329827402-12124-1-git-send-email-Jes.Sorensen@redhat.com> <20120222065335.268c8aae@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120222065335.268c8aae@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: meyering@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/21/12 20:53, NeilBrown wrote:
> On Tue, 21 Feb 2012 13:30:02 +0100 Jes.Sorensen@redhat.com wrote:
>> diff --git a/Create.c b/Create.c
>> index 90ff3ed..702ac34 100644
>> --- a/Create.c
>> +++ b/Create.c
>> @@ -926,7 +926,7 @@ int Create(struct supertype *st, char *mddev,
>>  			if (st->ss->write_init_super(st)) {
>>  				fprintf(stderr,
>>  					Name ": Failed to write metadata to %s\n",
>> -					dv->devname);
>> +					mddev);
>>  				st->ss->free_super(st);
>>  				goto abort_locked;
>>  			}
> 
> Hi Jes,
>  this doesn't seem right.  You message would print e.g.
> 
>     mdadm: Failed to write metadata to /dev/md1
> 
> but one doesn't write metadata to an array, one writes it to the member
> devices.
> Each ->write_init_super function should print out a message if a write
> fails.  So I think we just remove the error message here, and make sure
> each ->write_init_super does print an error in each case (there might be a
> couple of holes).
> 
> Could you try that approach instead?

Hi Neil,

Makes sense - this was the best I could do in the global context, but I
see the various write_init_super() functions already print errors.

Replacement patch coming your way in 60 seconds or so.

Cheers,
Jes
