From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Remote NAS
Date: Mon, 28 Sep 2009 08:15:47 -0600
Message-ID: <200909280815.47537.tfjellstrom@shaw.ca>
References: <41943.20139.qm@web38801.mail.mud.yahoo.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41943.20139.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon September 28 2009, adfas asd wrote:
> I am puzzled by why write-mostly.  Ostensibly Gb ethernet is supposed to
>  nearly equal the data transfer rate of the controller cards, and be many
>  times the speed of actual data transfer from the drives.
> 
> So shouldn't a NAS have plenty of bandwidth to accommodate most any drive
>  operations?

My GbE lan gets about 90MiB/s, my pcie sata card has shown upwards of 
400MiB/s. I haven't done full tests on the sata card yet, but it clearly is 
able to more than saturate a single GbE connection.

> I will be setting up a small high-perf drive for / (including database) so
>  the only data on the array will be /home (including large videos).
> 
> Seems like there is no need to specify write-mostly?
> 
> --- On Sun, 9/27/09, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> >     In his situation (assuming he doesn't
> > take my advice and separate
> > the remote system entirely), wouldn't he be better served
> > to create a RAIDn
> > array on both systems and then create a RAID1 from the
> > local and NAS array
> > with the write mostly option?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
