From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-6 with 3 missing disks
Date: Sat, 4 May 2013 20:28:01 +0200
Message-ID: <20130504182801.GA10115@lazy.lzy>
References: <20130504160804.GA2242@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130504160804.GA2242@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all again,

I solved the problem, maybe useful to know how.

I used the fully working disks (the 3 disconnected)
as reference and I recreated the configuration by
modifying the superblock information of the other
disks (including checksum).

The array was then working and the data was there,
at least to the extent I could check (all files
stored have MD5, but I did not check all).

Maybe one suggestion for "mdadm" future feature.
It would be nice to be able to perform such
operations, like forcing an assembly, also under
extreme condition.
With all the warnings of the case, of course.

bye,

pg

On Sat, May 04, 2013 at 06:08:04PM +0200, Piergiorgio Sartor wrote:
> Hi all,
> 
> I know this was probably already discussed, but
> maybe I need some refresh.
> 
> I've a 10 HDDs RAID-6 which, due to mishap (disks
> were disconnected accidentaly), has now 3 missing
> devices and cannot be assembled.
> The data should be OK, since no writes were occurring
> during the accident, so putting them together again
> should work.
> 
> As far as I know, one option is to create, with
> "mdadm -C" the array again, giving the disks in
> the proper order.
> 
> Since all HDDs are readable, I guess "mdadm -E"
> should return the role of each device.
> Is this correct for the creation order?
> 
> Second question is about the "Data Offset", since
> this array was created with an older version of
> "mdadm" and the data offset is very close to the
> superblock.
> As far as I know, new mdadm creates the data a
> bit far aways.
> Is there any way to specifiy the proper offset?
> 
> Finally, is there an alternative to "mdadm -C"
> or it is the only option?
> Forcing assembly does not work, but maybe there
> is another way to tell mdadm to really assemby
> the array, taking into account the superblock
> information, which are all readable.
> 
> Thanks a lot in advance,
> 
> bye,
> 
> -- 
> 
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
