From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 4 Jun 2013 11:39:07 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com>
 <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <51AD2485.9000601@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AD2485.9000601@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Joe Lawrence <Joe.Lawrence@stratus.com>
List-Id: linux-raid.ids

On Mon, 3 Jun 2013, H. Peter Anvin wrote:

> On 06/03/2013 11:35 AM, Martin K. Petersen wrote:
> >>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:
> > 
> > hpa> OK, so the device here says don't do this again, but fails the
> > hpa> request anyway expecting the block device to pick up the slack.
> > 
> > Yes, the block layer function will resort to writing out zeroes directly
> > in this case.
> > 
> > MD should not consider a rejected WRITE SAME a failure.
> > 
> 
> We should probably add Joe Lawrence to this thread.
> 
> Joe: basically it seems that the error behavior of md (at least raid10,
> but probably raid1 as well) on WRITE SAME is wrong, and it causes the
> RAID to abort.

Martin is probably the expert here (I had extended his initial WRITE SAME 
support in MD raid0 to raid1 and raid10), but I can try failing a WS cmd 
using our San Blaze emulator to see the fall out. 

Just curious, what type drives were in your RAID and what does
/sys/class/scsi_disk/*/max_write_same_blocks report?  If you have a spare 
drive to test, maybe you could try a quick sg_write_same command to see 
how the drive reacts?

-- Joe
