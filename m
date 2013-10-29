From: John Schmidt <johnschmidt4@gmail.com>
Subject: Re: [PATCH] mdadm.8.in
Date: Tue, 29 Oct 2013 14:37:21 -0700
Message-ID: <CACcY5UxRTf_R=pSX7+EWnJGO03n+9z6Kpr_DKnDwG1Cw5Zf2ig@mail.gmail.com>
References: <CACcY5Uxc2f6HOxLHt5DY5E71EvFbo0dNmtqUtH=FRwTitE=+zw@mail.gmail.com>
 <20131030083431.59e5d397@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131030083431.59e5d397@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Thank you!

On Tue, Oct 29, 2013 at 2:34 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 29 Oct 2013 10:16:18 -0700 John Schmidt <johnschmidt4@gmail.com>
> wrote:
>
>> I found a small bug in the documentation of mdadm.  I fixed it in my
>> local git clone of git://neil.brown.name/mdadm  Here is the change:
>>
>> git diff mdadm.8.in
>> diff --git a/mdadm.8.in b/mdadm.8.in
>> index 09aff81..006ae59 100644
>> --- a/mdadm.8.in
>> +++ b/mdadm.8.in
>> @@ -529,7 +529,7 @@ amount of available space is.
>>  .BR \-c ", " \-\-chunk=
>>  Specify chunk size of kibibytes.  The default when creating an
>>  array is 512KB.  To ensure compatibility with earlier versions, the
>> -default when Building and array with no persistent metadata is 64KB.
>> +default when building an array with no persistent metadata is 64KB.
>>  This is only meaningful for RAID0, RAID4, RAID5, RAID6, and RAID10.
>>
>>  RAID4, RAID5, RAID6, and RAID10 require the chunk size to be a power
>>
>> Let me know if there are other things I need to do to get this patch submitted.
>>
>> Thank you,
>> John Schmidt
>> johnschmidt4@gmail.com
>
>
> applied.  Thanks.
>
> NeilBrown
