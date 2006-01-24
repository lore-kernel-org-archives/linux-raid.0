From: Neil Brown <neilb@suse.de>
Subject: Re: blog entry on RAID limitation
Date: Tue, 24 Jan 2006 14:20:25 +1100
Message-ID: <17365.40185.142492.320225@cse.unsw.edu.au>
References: <8E5ACAE05E6B9E44A2903C693A5D4E8A097F6C86@hqemmail02.nvidia.com>
	<1137487538.309F9186@bd12.dngr.org>
	<17356.51593.481883.173707@cse.unsw.edu.au>
	<43CD1E5A.3050802@mungo.dk>
	<17357.29686.842091.898632@cse.unsw.edu.au>
	<17362.40597.2229.222073@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carlos Carvalho on Saturday January 21
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday January 21, carlos@fisica.ufpr.br wrote:
> Neil Brown (neilb@suse.de) wrote on 18 January 2006 09:47:
>  >On Tuesday January 17, jacob@mungo.dk wrote:
>  >> Neil Brown wrote:
>  >> > In general, I think increasing the connection between the filesystem
>  >> > and the volume manager/virtual storage is a good idea.
> 
> Well, I agree in principle however the increase in complexity is
> likely to make the whole thing even harder to be as reliable as one
> needs... Just consider the complication of xfs or reiser4...

I wouldn't generally expect current filesystems to be enhanced to
understand volume management.  Rather that new filesystems would
include volume management in their core design (like ZFS does).
The ext3 enhancement I mentioned is an exception to this, and it is a
very light-weight integration between FS and LVM.

If you think about it, volume management concepts are largely very
simple, and are very similar to some filesystem concepts.
Doing them both together makes a lot of sense - it leverages the
synergies (if you'll excuse the buzzwords).

A lot of the complexity in volume management comes from trying to
present an illusion of a single large device to the filesystem.  If
you didn't have to construct that illusion, you would need a lot less
code.

The blog entry which started this thread made some comment about how
little code was need for the raid-X implementation.  I suspect this is
largely because there is no need to create illusions.

> 
>  >I have had a project underway for some time (about half a day a week
>  >at the moment) to create a file system which is raid-friendly.  When
>  >configured on a raid5, it will always write a full stripe at a time,
>  >and never over-write live data.  This means that there is no need to
>  >pre-read parity or data, and it completely removes the "write hole".
> 
> This seems interesting not so much because of the write-hole but
> because of the possible increase in speed. I'm not going to ask about
> the filesystem features because I think you already said in the list
> that you want to play with it yourself :-)

I plan to post my code and doco somewhere once I get to a particular
milestone.  However that milestone seems to keep receding into the
distance....
I want the kernel module that I am writing to have substantial
read-only functionality on a filesystem that spans multiple devices.
However I have been waylaid by having the rewrite the directory
handling because my first draft didn't provide stable seek offsets for
filenames, and that really is a 'MUST'.

NeilBrown


> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
