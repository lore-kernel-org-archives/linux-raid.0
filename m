From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdadm: replace hard coded string length
Date: Fri, 16 Sep 2016 08:34:44 -0400
Message-ID: <wrfjpoo4qazf.fsf@redhat.com>
References: <1473898407-3049094-1-git-send-email-songliubraving@fb.com>
        <wrfjr38lxhp9.fsf@redhat.com> <5328253.xG1N6xNRzL@natasha>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5328253.xG1N6xNRzL@natasha> (Thomas Fjellstrom's message of
        "Thu, 15 Sep 2016 12:10:13 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Fjellstrom <thomas@fjellstrom.ca> writes:
> On Thursday, September 15, 2016 12:15:30 PM MDT Jes Sorensen wrote:
>> Song Liu <songliubraving@fb.com> writes:
>> > @@ -1124,7 +1124,7 @@ static int update_super1(struct supertype *st,
>> > struct mdinfo *info,> 
>> >  		if (c)
>> >  		
>> >  			strncpy(info->name, c+1, 31 - (c-sb->set_name));
>> >  		
>> >  		else
>> > 
>> > -			strncpy(info->name, sb->set_name, 32);
>> > +			strncpy(info->name, sb->set_name, sizeof(sb->set_name));
>> > 
>> >  		info->name[32] = 0;
>> >  	
>> >  	}
>> 
>> I was about to apply this, but this is actually wrong. You need to use
>> the size of the destination, not of the source as the limit.
>> 
>> Sorry for the hassle.
>
> I'm not aware of the full details, but either they are the same size, or they 
> aren't, and you need to use the minimum size of both to avoid any kind of 
> overflow (source or dest, read and write). I presume the destination is 
> smaller?

When copying a null terminated string, you need to check against the
size of the destination, not the source. It may happen to be they are
the same size here, but if code is later moved around you could get into
a situation where that is no longer the case. Checking against the size
of the destination is the correct way.

Second, when you reply to a mailing list posting, kindly refrain from
removing the person you respond to from the CC list.

Jes
