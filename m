From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: metadata and / and grub-static
Date: Mon, 05 Apr 2010 17:31:23 +0100
Message-ID: <4BBA105B.2040609@anonymous.org.uk>
References: <u2u5bdc1c8b1004041902l9edc298dg6fb4774aaf8c22a6@mail.gmail.com>	 <2D.29.28131.56A49BB4@cdptpa-omtalb.mail.rr.com>	 <r2m5bdc1c8b1004050715q6db273f9o8d1c291a43ebd308@mail.gmail.com>	 <4BB9F9E4.2060802@anonymous.org.uk> <q2v5bdc1c8b1004050852j98b4b91fne8dea1399892862f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <q2v5bdc1c8b1004050852j98b4b91fne8dea1399892862f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/04/2010 16:52, Mark Knecht wrote:
[...]
> John,
>    Thanks for the summary. It's succinct and covered the info I needed
> this weekend.

In which case, apologies for not answering until Monday afternoon :-)

>    One question comes to mind. I'm about to build a Gentoo machine
> that will run a number of copies of Windows in VirtualBox VMs. The
> system will be nice, reliable RAID1 for all of Linux, and then 'fast'
> RAID0 on different drives for the VM data. As there will be nothing
> involved with booting Linux on this RAID - just the VM data. I assume
> that there's no problem assembling RAID0 after the boot process has
> essentially completed, and that this RAID could use any form of
> metadata?

Yep. You could do this with /home /usr /var too. I expect Gentoo's init 
scripts will run mdadm for you before mounting the other filesystems; 
the other distros generally do.

Cheers,

John.
