From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm --add Device or resource busy error and multiple drives
 	"failing" on RAID 6 at once
Date: Fri, 16 Jul 2010 13:55:34 +0100
Message-ID: <4C4056C6.6090501@anonymous.org.uk>
References: <AANLkTikx_L6R0839o-MWu2CscFEdhlSf65a2cGTPl1Ex@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikx_L6R0839o-MWu2CscFEdhlSf65a2cGTPl1Ex@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "fibreraid@gmail.com" <fibreraid@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/07/2010 12:54, fibreraid@gmail.com wrote:
> I am using Ubuntu Jaunty (9.04) 64-bit with mdadm 2.6.9 on a whitebox
> server with 8GB RAM and dual Xeon quad-core CPUs. I have a RAID 6
> consisting of 12 drives all located in the same enclosure, using the
> 1.2 superblock. For some reason, mdadm seems to "kick out" numerous
> drives out of the array at once (sometimes 5 or more). This results in
> a degraded state. I've tried replacing the cabling, SAS controller to
> which the drives are connected, and even updating the drive firmware
> but mdadm still seems to do this on occasion (like once a week). I am
> highly doubting all these drives are failing at once. Any further
> ideas on what might be causing this issue?

I recognise these symptoms from earlier postings, relating to problems 
with the driver for a controller card/chip (I forget which one) and 
S.M.A.R.T. - you might grep the list archives for references to your 
controller.

Cheers,

John.
