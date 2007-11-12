From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid5 assemble after dual sata port failure
Date: Sun, 11 Nov 2007 20:01:00 -0500
Message-ID: <4737A5CC.8040105@tmr.com>
References: <47321FDF.8060207@synplicity.com> <4732E5F0.7080805@dgreaves.com> <4734CFE5.8070305@synplicity.com> <4734FB4A.4070401@synplicity.com> <473576F9.6040602@dgreaves.com> <4735FC7E.7030601@synplicity.com> <47373746.9090701@dgreaves.com> <47373EB9.9050408@synplicity.com> <4737870D.5000906@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4737870D.5000906@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Chris Eddington <chrise@synplicity.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Chris Eddington wrote:
>   
>> Yes, there is some kind of media error message in dmesg, below.  It is
>> not random, it happens at exactly the same moments in each xfs_repair -n
>> run.
>> Nov 11 09:48:25 altair kernel: [37043.300691]          res
>> 51/40:00:01:00:00/00:00:00:00:00/e1 Emask 0x9 (media error)
>> Nov 11 09:48:25 altair kernel: [37043.304326] ata4.00: ata_hpa_resize 1:
>> sectors = 976773168, hpa_sectors = 976773168
>> Nov 11 09:48:25 altair kernel: [37043.307672] ata4.00: ata_hpa_resize 1:
>> sectors = 976773168, hpa_sectors = 976773168
>>     
>
> I'm not sure what an ata_hpa_resize error is...
>   

HPA = Hardware Protected Area.

By any chance is this disk partitioned such that the partition size 
includes the HPA? If it does, this sounds at least familiar, this 
mailing list post may get you started: 
http://osdir.com/ml/linux.ataraid/2005-09/msg00002.html

In any case, run "fdisk -l" and look at the claimed total disk size and 
the end point of the last partition. The HPA is not included in the 
"disk size" so nothing should be trying to do so.
> It probably explains the problems you've been having with the raid not 'just
> recovering' though.
>
> I saw this:
> http://www.linuxquestions.org/questions/linux-kernel-70/sata-issues-568894/
>   

May be the same thing. Let us know what fdisk reports.
>
> What does smartctl say about your drive?
>
> IMO the spare drive is no longer useful for data recovery - you may want to use
> ddrescue to try and copy this drive to the spare drive.
>
> David
> PS Don't get the ddrescue parameters the wrong way round if you go that route...
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

