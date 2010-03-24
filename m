From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Information gathering script
Date: Wed, 24 Mar 2010 15:51:50 +0000
Message-ID: <73e903671003240851h3c5b92bep98b4dc07392b4759@mail.gmail.com>
References: <4BAA2B55.8040504@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAA2B55.8040504@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 24, 2010 at 3:10 PM, Brad Campbell <brad@wasp.net.au> wrote:
> G'day all,
>
> Having just dropped a drive (it turns out 1TB SATA drives don't bounce) that
> belonged in my 10 drive RAID-6 and having replaced it this afternoon, I had
> a thought.
>
> When things go wrong (particularly those nasty things that cause the sick
> feeling in the pit of your stomach) the best help is always available give
> the right information.
>
> If there was a script that one could run when things were healthy that
> dumped all the relevant information for safe keeping, would it reduce the
> nightmare that is recovering a broken raid?
>
> I'd imagine an mdadm --examine on each component of a RAID, partition tables
> and perhaps a --detail on each md device. Is there anything else that might
> be handy that could be dumped to a verbose output just in case?
>
> Is there already such a thing?
>
> Regards,
> Brad

In my paranoia, I did this type of thing manually the other day.
(Great minds think alike?)

- I took the output of "lshw". Handy overview. Shows drive types,
serial numbers, drive-to-controller connections.
- It'd be very useful to have the UUID serials of each drive plus the
exact order they are assembled into the raid.
- And well, having a binary copy of all the superblocks and partition
tables sure can't hurt.

-- Kristleifur
