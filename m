From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Tue, 04 Jun 2013 08:46:12 -0700
Message-ID: <51AE0BC4.3070904@zytor.com>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <51AD2485.9000601@zytor.com> <alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/04/2013 08:39 AM, Joe Lawrence wrote:
>>
>> We should probably add Joe Lawrence to this thread.
>>
>> Joe: basically it seems that the error behavior of md (at least raid10,
>> but probably raid1 as well) on WRITE SAME is wrong, and it causes the
>> RAID to abort.
> 
> Martin is probably the expert here (I had extended his initial WRITE SAME 
> support in MD raid0 to raid1 and raid10), but I can try failing a WS cmd 
> using our San Blaze emulator to see the fall out. 
> 
> Just curious, what type drives were in your RAID and what does
> /sys/class/scsi_disk/*/max_write_same_blocks report?  If you have a spare 
> drive to test, maybe you could try a quick sg_write_same command to see 
> how the drive reacts?
> 

The drives are SATA drives connected via mptsas.  max_write_same_blocks
show 65535.  Unfortunately the problems are rare enough that it didn't
pop up until the server was put in production, so I would like to avoid
experimenting on it as much as possible.

	-hpa


