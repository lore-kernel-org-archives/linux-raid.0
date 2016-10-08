From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: md-cluster - Assemble/Scan During Resync
Date: Sat, 8 Oct 2016 02:57:14 -0400
Message-ID: <57F898CA.30806@suse.com>
References: <CAHkw+Lc3XGqTL5pLX=UhQ+-kdHiVDPO8Z+EbTkWjyk6RgW5tug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+Lc3XGqTL5pLX=UhQ+-kdHiVDPO8Z+EbTkWjyk6RgW5tug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Marc,

On 10/05/2016 04:43 PM, Marc Smith wrote:
> Hi,
>
> First, I believe this issue may have been reported/solved with this
> thread ("[PATCH 3/3] MD: hold mddev lock for md-cluster receive
> thread"):
> http://www.spinics.net/lists/raid/msg53121.html
>
> But I'm not totally sure, and I'm looking for confirmation, or maybe
> this is a new one... I'm trying to hold out for Linux 4.9 in my
> project, and I am hoping to just cherry pick any patches until then.
>
> Testing md-cluster with Linux 4.5.2 (yes, I know its dated)... two
> nodes connected to shared SAS storage, and I'm using DM Multipath in
> front of the individual SAS disks (two I/O modules with dual-domain
> SAS disks).

For cluster-md, there are lots of changes since v4.5, and there are some
fixes which are just merged in 4.9 window (I personally think it should
be stable).

> On tgtnode2 I created the array like this: mdadm --create --verbose
> --run /dev/md/test4 --name=test4 --level=raid1 --raid-devices=2
> --chunk=64 --bitmap=clustered /dev/dm-4 /dev/dm-5
>
> And then, without waiting for the resync to complete, on the second
> node (tgtnode1) I do this: mdadm --assemble --scan

I can't reproduce it with latest code, pls let me know if you see it again
with v4.9 (also send the stack of md related process which are in 'D'
state).

[snip]

> So, again, this may already be fixed, just looking for confirmation if
> the aforementioned patch / thread is related to this bug (or maybe
> another).

Not the one you mentioned (it was not merged), actually there are lots
of changes for resync, you can bisect them to find the related commit.

Thanks,
Guoqing
