From: Marcus <shadowsor@gmail.com>
Subject: Re: [PATCH 00/24] Clustered MD RAID1
Date: Fri, 26 Dec 2014 16:47:36 -0800
Message-ID: <CALFpzo4gO1A9i-JguhKprCWuicWO+HvhHA1MrfmwGUt5QuJQ8A@mail.gmail.com>
References: <20141218161456.GA29504@shrek.lan>
	<5499A55E.3010705@suse.de>
	<549DE299.3010205@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <549DE299.3010205@kieser.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Neil Brown <neilb@suse.de>, lzhong@suse.com, john@stoffel.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I don't think it's any different than exposing the same block device
to multiple servers, like an iSCSI or FC volume. It just allows you to
also treat a RAID device like you would any other SAN-type block
device by keeping the MD metadata consistent.  You still have to
either put something on top of it that will be aware of the fact that
other hosts can see the block device and maintains its own consistency
(clustered FS), or be sure to only use it on one host at a time, again
like you would treat any other SAN volume.

On Fri, Dec 26, 2014 at 2:35 PM, Peter Kieser <peter@kieser.ca> wrote:
>
> On 2014-12-23 9:24 AM, Goldwyn Rodrigues wrote:
>>
>> This md device can be used as a regular shared device. There are no
>> restrictions on the type of filesystem or LVM you can use, as long as
>> you observe clustering rules of using a shared device.
>
>
> This is very vague. I feel like this is a huge layering violation. LVM or
> filesystem on top of mdadm should not have to be aware of what is going on
> below. Otherwise, I feel like other clustered filesystems that include RAID
> are better suited. As it stands, what are the benefits of using this over
> $CLUSTER_FS?
>
> -Peter
>
