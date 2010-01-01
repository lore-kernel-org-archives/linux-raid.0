From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Size limitation?
Date: Fri, 01 Jan 2010 15:42:35 -0600
Message-ID: <4B3E6C4B.20604@gmail.com>
References: <201001011457.24334.mmclagan@invlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201001011457.24334.mmclagan@invlogic.com>
Sender: linux-raid-owner@vger.kernel.org
To: mmclagan+reply@invlogic.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael McLagan wrote:
> Hello,
> 
>    I'm trying to set up a large array but isn't working.  I tried 
> Googling size limits, etc and came up empty.
> 
> The problem is that with 10 drives (300GB SCSI), the array is coming up 
> with 500GB of space?!?  I did an experiment and when the array size 
> exceeds 2TB, it fails/wraps?
> 
> Is there a solution (simple or otherwise) for this?  The machine runs 
> 2.6.29.5 (anything later causes the machine to lock up :( ).  I'm not 
> sure if mdadm or the kernel is the problem either.
> 
> Any suggestions appreciated (please CC me on replies).
> 
>    Michael
> 
>

Just guessing it is a mdadm bug.

I have a 32-bit 2.6.27.5 machine with mdadm 2.6.7 and mine is showing 
an array size of 4.5tb correctly, so 2.6.29 should be just fine.

Check mdadm --version and see what version that you have of that, you 
might also mount up the array and do "cat /proc/mdstat" and see what 
size the kernel reports.
