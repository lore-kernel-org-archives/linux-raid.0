From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Implementing --detail-platform for DDF
Date: Fri, 13 Sep 2013 19:25:22 +0200
Message-ID: <52334A82.8070303@arcor.de>
References: <5230D9D6.7030005@arcor.de> <CAA9_cmcoSkDL_afvnBL09eSryAPYd-90wk1XJZ_Hvo4CdEQgpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcoSkDL_afvnBL09eSryAPYd-90wk1XJZ_Hvo4CdEQgpg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 09/13/2013 02:18 AM, Dan Williams wrote:
> On Wed, Sep 11, 2013 at 2:00 PM, Martin Wilck <mwilck@arcor.de> wrote:
>> Hi Neil,
>>
>> I thought I might come up with an implementation of mdadm
>> --detail-platform for DDF, but I encountered a problem I'd like to discuss.
>>
>> For DDF, we can't scan PCI devices like IMSM does, because we don't know
>> all controllers supporting DDF. Thus I considered scanning block devices
>> instead and looking at "foreign" vendor strings in the meta data;
>> possibly also filtering by device names or types. It occured to me that
>> it might be elegant to simply call conf_get_devs() for a list of devices
>> to be scanned. But if I do that, config.o and its dependencies must be
>> linked with mdmon, blowing up its size considerably. I figure that
>> that's a no-go. But I'm also reluctant to write my own DDF-specific
>> block device scanning code while there is conf_get_devs() already.
>>
>> Perhaps I am misunderstanding the purpose of --detail-platform?
>> I wouldn't bother with it if YaST2/libstorage didn't call it in order to
>> check if a "fake RAID" platform is present.
> 
> --detail-platform is more about finding the presence of the raid
> option-rom / firmware support.  I can imagine the installer may want
> to confirm that an array is bootable before installing to it.
> 
> Is it enough to scan for devices that self-report as raid controllers?
>  Problem then becomes finding a cross-implementation method to parse
> the firmware signature to detect DDF capabilities.

That'd certainly be nice to have, but I can't imagine a way how to
collect these data unless the vendors contribute directly, as Intel did.
For LSI I'd be able to dig up a list of PCI IDs of RAID-capable
controllers, but that's about all I can think of. For other vendors I
have no information.

Regards
Martin


> 
> --
> Dan

