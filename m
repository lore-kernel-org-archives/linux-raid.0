From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Performance question
Date: Wed, 21 Jan 2009 01:15:03 +0100
Message-ID: <20090121001503.GA26587@rap.rap.dk>
References: <20090117171806.GA9432@lazy.lzy> <20090117220849.GB29866@rap.rap.dk> <20090119181253.GA4290@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090119181253.GA4290@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 19, 2009 at 07:12:53PM +0100, Piergiorgio Sartor wrote:
> Hi,
> 
> thanks for the answer, that was exactly what I
> was looking for.

Good!

> Some feedback for you.
> About the performance & benchmarking I've nothing
> special to say.
> About the setup of two disks, I've some questions,
> in no particular order.
> 
> The creation of "mdadm.conf" is done by:
> 
> mdadm --detail --scan
> 
> Somewhere else I found:
> 
> mdadm --examine --scan
> 
> The two produce different results and the Fedora
> installer seems to use the second one.
> 
> Which one is really correct? Can we use one or the
> other interchangeably?

--detail looks at the running arrays, while --examine most
likely (depending on mdadm.conf) looks at all partitions
on the system. 

Given that the arrays are just created in the installation process, and
the active running arrays are most likely the ones you want your system
to know of, I think --detail is the better. --examine does on two of my
systems generate info that are in conflict and not suitable for a
mdadm.conf file, such as two /dev/md1 with different UUIDs.

> Second question.
> The wiki page does not mention anything about
> metadata types.
> While it is clear that /boot must have the RAID
> header at the end, it is not clear if the RAID-10,f2
> could or should have the metadata at the beginning.
> In this respect, it would be nice also to have some
> clarification about the reccommended metadata version,
> i.e. is it better 0.90 or 1.x? Why?

To me it does not matter that much, except for the booting device.
Each partition in the booting device must look like a normal (ext3)
partition, as grub and lilo does not know of raids, and just treats
a booting partition as a standalone partition. So here you should use
0.90 metadata, which is put at the end of the array.

For other arrays I think one important choice is if you have an array
greater than 2 TiB to not use 0.90 metadata, as this has a limit of 2
TiB.

> One note. Maybe it could be worth to mention that
> further "partitioning" could be done with LVM on top
> of the RAID, so only 3 md devices will be needed.

yes, I have been looking into that. Maybe I will add some words on this.

> Hope this helps.


yes, thanks for your feedback!

best regards
keld
