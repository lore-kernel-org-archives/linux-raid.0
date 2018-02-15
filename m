From: Phil Turmel <philip@turmel.org>
Subject: Re: Automatically start two-level mdadm RAID arrays (i.e. RAID 60) on
 boot?
Date: Thu, 15 Feb 2018 16:51:22 -0500
Message-ID: <4ebbb6bf-70a9-fb85-1b9f-82850a187e47@turmel.org>
References: <CAA43vkUG8LrMUjazeYFtGVKVuTvrYRPe-UcPb21r=xeYpctpmg@mail.gmail.com>
 <20180216020217.2a9c7690@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180216020217.2a9c7690@natsu>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, Sean Caron <scaron@umich.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/15/2018 04:02 PM, Roman Mamedov wrote:
> On Thu, 15 Feb 2018 15:41:37 -0500
> Sean Caron <scaron@umich.edu> wrote:
> 
>> Hi all,
>>
>> My site is very happily using MD RAID arrays constructed in two
>> levels. That is to say, we do RAID 60 by constructing an mdadm RAID 0
>> out of a number of mdadm RAID 6 strings.
>>
>> These work great but one thing we have found and been living with is
>> that, when the system boots, mdadm will automatically start all the
>> RAID 6 strings, but it will not automatically start the top level RAID
>> 0 container. The machine pauses on boot ("Hit S to skip, M to manually
>> resolve") trying to mount the RAID because the device is not
>> available, and a sys admin needs to manually go to the console and
>> start the top level RAID 0 to continue the boot.
> 
> I had RAID5/6 with some members being RAID0s. IIRC it was a simple matter of
> listing them in the correct order of initialization in mdadm.conf. Not sure if
> this was strictly required, just that I did so right away (expecting that it
> would be), and everything simply worked.
> 
> On the other hand, these days you likely have systemd, and it never misses its
> chance to make people's lives much more interesting than that.
> 

No, it sounds like an old distro that isn't using udev and incremental
assembly.  I don't know of a solution.

Phil
