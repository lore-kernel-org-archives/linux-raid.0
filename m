From: Jake Thomas <thomasj10@georgefox.edu>
Subject: Re: Device Unusable At Startup
Date: Fri, 28 Sep 2012 05:12:33 -0700
Message-ID: <AE75A61C-0EF0-422C-9F83-1D72F4C5303D@georgefox.edu>
References: <CACO8vipp6mWQCY-cWhSbty=XNKFoxc_q_ntv-0C+dKsRD8DEWA@mail.gmail.com> <506585C6.10403@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <506585C6.10403@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well, all automatically generated md devices are numbered from md127 down.

You may have some manually specified md devices going from md0 up (such as via kernel parameters or scripts).

Either one of those two categories may contain working md arrays.

So, since there very well could be automatically generated _working_ md devices in the "high range", no, you can't assume that all working md devices are in the low range.

Thanks for the "range syntax" tip. I didn't know about it.


Also note that in my particular situation, md0 does not exist until after I stop the borked array.

Jake

Sent from my iPhone

On Sep 28, 2012, at 4:11 AM, Jan Ceuleers <jan.ceuleers@gmail.com> wrote:

> On 09/28/2012 01:47 AM, Jake Thomas wrote:
>> Note that all md devices must be stopped using a wildcard: "/dev/md*"
>> because we technically don't know
>> for sure what the name of the md device is that holds /usr. It could
>> be /dev/md127, /dev/md126, /dev/md125
>> or whatever. We simply don't know. If it's the only md device present,
>> it will, with almost 100% certainty, be /dev/md127,
>> but what if someone plugs in USB drives that have mdraid before you
>> turn the computer on? Now we really don't know.
>> Or, more likely, if you have more than one md raid array amongst your
>> internal hard drives, we wouldn't know the name of the one we must
>> stop to reassemble.
>> 
>> Unfortunately, /dev/disk/by-uuid is not populated for this md device,
>> because it is currently broke. So we can't specify it by uuid
>> or anything. A system-wide stopping of all md devices (/dev/md*) must
>> be done to stop it.
> 
> Would it be a fair expectation for any non-borked arrays to be numbered
> starting at /dev/md0 ? So that only the arrays numbered above 100 to be
> likely borked?
> 
> If so you could try limiting the mdadm --stop to only /dev/md1[0-9][0-9]
> or something like that.
> 
> HTH, Jan
