From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Implementing --detail-platform for DDF
Date: Thu, 12 Sep 2013 20:14:20 +0200
Message-ID: <5232047C.7030309@arcor.de>
References: <5230D9D6.7030005@arcor.de> <20130912160043.54d73613@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130912160043.54d73613@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/12/2013 08:00 AM, NeilBrown wrote:
> On Wed, 11 Sep 2013 23:00:06 +0200 Martin Wilck <mwilck@arcor.de> wrote:
> 
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
>>
>> Regards
>> Martin
> 
> I think it would be wrong for --detail-platform to look at the contents of
> disk drives.  If anything, it must look at the 'platform' - the controller.
>
> If YaST2 uses --detail-platform for anything other than IMSM it is
doing it
> wrong.

The current libstorage logic is as follows:
 1. runs mdadm --detail-platform to see if there is IMSM
    no -> 2, yes -> 3
 2. start dmraid, then mdadm. -> 5
 3. run mdadm -Es to derive a list of array names, and ask user if he
wants to drive these arrays with mdadm  (this will look weird to the
user if the array names are empty).
    no -> 2, yes -> 4
 4. start mdadm, then dmraid
 5. proceed with LVM etc.

> I'm currently building a virtual machine running openSUSE 13.1-M4 with DDF
> devices.  I'll see what yast thinks of it...

You may want to have a look at
https://build.opensuse.org/project/show/home:mwilck:mdadm-DDF:openSUSE

It contains almost-up-to-date mdadm and tentative patches for
libstorage. I successfully installed both OpenSUSE 12.3 and Factory with
these packages on a DUD. The libstorage patch I am using is pretty
simplistic but it does the job.

Martin


