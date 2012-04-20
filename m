From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Removing a failing drive from multiple arrays
Date: Fri, 20 Apr 2012 17:31:24 +0100
Message-ID: <4F918F5C.2000607@anonymous.org.uk>
References: <4F905F66.6070803@tmr.com> <20369.29756.761374.308057@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20369.29756.761374.308057@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/04/2012 15:35, John Stoffel wrote:
>
> Bill>  I have a failing drive, and partitions are in multiple
> Bill>  arrays.
>
> Ugh!  Why?  This is why I love LVM on top of MD.  I just mirror
> drives, then carve them up as needed.  Yes, you need to have two (or
> more) drives of the same approximate size, but that's easy.
>
> Mirroring partitions just seems to be asking for trouble to me.

On small machines (3-6 drives) I will regularly have a RAID-1 /boot, 
RAID-10 swap and RAID-5 or 6 everything else, done with partitions. I do 
use LVM too though - that "everything else" will be LVM over the big RAID.

Cheers,

John.

