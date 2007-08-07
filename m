From: "saeed bishara" <saeed.bishara@gmail.com>
Subject: Re: Linux RAID migration
Date: Tue, 7 Aug 2007 13:02:47 +0300
Message-ID: <c70ff3ad0708070302g1d23f4c8qd53c230d4118fd51@mail.gmail.com>
References: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com>
	 <5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Tuomas Leikola <tuomas.leikola@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/7/07, Tuomas Leikola <tuomas.leikola@gmail.com> wrote:
> On 8/7/07, saeed bishara <saeed.bishara@gmail.com> wrote:
> > Hi,
> >  I'm looking for a method for doing RAID migration while keeping the
> > data available.
> > the migrations I'm interested with are:
> > 1. Single drive ->RAID1/RAID5
> > 2. RAID1 -> RAID5.
> >
>
> 1. is a bit complicated, as a raid device on a disk is slightly
> smaller than the original device. you might need to copy data
> manually.
   I think I can overcome this problem by creating linear raid on the
initial disk.
>
> 2. should be simple as (offline) re-creating the raid as raid5.
this didn't work, I created raid1 array on sda[12], then stopped it,
and created new raid5 on sda[123], the data on the raid1 was not
preserved.
>
> > - can I really assume that RAID 5 on 2 hdds (degraded mode) will
> > function as raid 5?
>
> You should test by using loopback devices and files. But why degraded?
> raid5 of two disks should look like raid1.
I meant to ask whether raid 5 on 2 disks will function as raid1 :(
>
> > - how to build raid while keeping the contents of an existing drive available?
>
> Normally the array is available when building/rebuilding.
>
> - tuomas
>
