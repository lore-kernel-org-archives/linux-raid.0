From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Antw: Problems creating MD-RAID1: "device .. not suitable for
 any style of raid array" / "Device or resource busy"
Date: Wed, 11 May 2011 18:00:35 +0100
Message-ID: <4DCAC0B3.8010509@anonymous.org.uk>
References: <4DCABB80020000A100005D46@gwsmtp1.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCABB80020000A100005D46@gwsmtp1.uni-regensburg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/05/2011 15:38, Ulrich Windl wrote:
> Hi!
>
> I could reduce the problem to "--bitmap internal": It works if I leave it out. Unfortunately the RAID will fully resync every assembly when there was an unclean shutdown.
> The thing that kept one device busy was MD-RAID itself: "mdadm -- stop" released the device.
>
> So to summarize:
> 1) mdadm fails to set up an internal bitmap
> 2) Even when mdadm fails to do 1), it starts the array

OK. First up, the syntax is "--bitmap=internal" - perhaps you have a 
mdadm which is partially parsing what you've said but not got it 100% 
right. If using the correct syntax doesn't work, instead try creating 
the array without the bitmap, then adding one with
   mdadm --grow /dev/mdX --bitmap=internal

Cheers,

John.

