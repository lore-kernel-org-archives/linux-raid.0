From: Kapetanakis Giannis <bilias@edu.physics.uoc.gr>
Subject: Re: large filesystem corruptions
Date: Sat, 13 Mar 2010 02:29:21 +0200
Message-ID: <4B9ADC61.7080007@edu.physics.uoc.gr>
References: <4B9A9D81.3000009@edu.physics.uoc.gr> <4B9AA5AC.9090005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9AA5AC.9090005@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/03/10 22:35, Ric Wheeler wrote:

> This is probably an issue with the early version of ext4 you are using -
> note that the support for ext4 > 16TB is still gated by some work done
> up in the tools chain.
>
> Have you tried xfs?
>
> regards,
>
> Ric

Thanks for answering,

My filesystem would be 15 TB < 16 TB.
GFS also crashed and burned so are you sure that this
this is a problem with ext4?
Would Fedora and newer kernel be better?

On my tests the crashing filesystem was 7TB.
When I added a second fs of 2 TB on lvm, so total > 8TB
I had the crash.

I did a new test now and didn't use GFT partitions
but the whole physical/logical drives

sdb -
     | ---> md0 ---> LVM ---> ext4 filesystems
sdc -

all sdb, sdc, md0 are gpt labeled without gpt partitions
inside. No crash so far but without any data written.

Maybe the gpt partitions did the bad thing?
Can md0 use large gpt drives with no partitions?
can lvm2 use large raid device with no partition pv?

I could try XFS but i'm not familiar with it,
so I wouldn't know the optimized values for
such a large fs

regards,

Giannis

