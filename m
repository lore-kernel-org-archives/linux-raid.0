From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: Scrubbing "check" not working for RAID10 in 3.10-rc1+
Date: Wed, 17 Jul 2013 13:24:55 -0500
Message-ID: <6EB9BA19-19FB-49D0-B9B6-EF886B54DAE7@redhat.com>
References: <1372141160.2016.0.camel@f16> <20130625163221.6f25f83d@notabene.brown> <3D105022-CB87-4BA7-9ACB-A31A2B25694D@redhat.com> <20130716170130.44a0db05@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130716170130.44a0db05@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jul 16, 2013, at 2:01 AM, NeilBrown wrote:

> On Mon, 15 Jul 2013 10:35:07 -0500 Brassow Jonathan <jbrassow@redhat.com>
> wrote:
> 
>> 
>> On Jun 25, 2013, at 1:32 AM, NeilBrown wrote:
>> 
>>> On Tue, 25 Jun 2013 01:19:20 -0500 Jonathan Brassow <jbrassow@redhat.com>
>>> wrote:
>>> 
>>>> Neil,
>>>> 
>>>> I've noticed that the "check" operation no longer works for RAID10.  It
>>>> works just fine for the other RAIDs.  The ("data-check") sync_thread
>>>> kicks off just fine, sync_request_write() is called, but it never gets
>>>> past:
>>>>       if (i == conf->copies)
>>>>               goto done;
>>>> The test I am performing creates a RAID array, waits for it to sync,
>>>> shuts it down, writes random data to one of the devices, assembles the
>>>> array, and then runs a "check" - there should be descrepancies.  The
>>>> descrepancies are found and recorded in resync_mismatches for all RAIDs
>>>> <= 3.9 and only for non-RAID10 3.10-rc1+.
>>> 
>>> I just tried on 3.10-rc5+ and it works as expected.
>>> If you can provide a test script that fails, I'll look into it.
>> 
>> Just tried 3.10 - it fails for me there too.  I'll send you the script I use shortly.
>> 
>> thanks,
>> brassow
>> 
>> (vacation ends soon.)
> :-)
> 
> Thanks.  This patch seems to fix it.

Yes, it does.  Thanks!

 brassow

