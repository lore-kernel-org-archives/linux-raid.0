From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: sector size mismatch a problem for RAID 1?
Date: Fri, 3 Feb 2017 11:20:17 +0000
Message-ID: <58946771.4030005@youngman.org.uk>
References: <3dcb5a7a-9bd4-4cfd-a655-91a88692c549@EXHT01.net.ucsf.edu>
 <d05e3579-38c4-40bd-8fb4-d296fc3ea9c5@EXHT02.net.ucsf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d05e3579-38c4-40bd-8fb4-d296fc3ea9c5@EXHT02.net.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Boylan, Ross" <Ross.Boylan@ucsf.edu>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/02/17 06:18, Boylan, Ross wrote:
> When I moved the new disk to an internal drive bay (after reading lvm-raid wiki's statements that RAID shouldn't be used over a USB link) the problems went away--at least so far.
> 
As I understand it, the problem is that the USB interface goes to sleep.
So when you try to write to it, it may not wake up quick enough, causing
havoc ...

> I wonder if this  is the source of my original problem: I was using a single disk RAID1 where the single disk had a USB connection.  However, I did get a failure off that drive doing a dd off the raw device.
> 
Quite likely. But I'm puzzled as to why the dd would fail, as this would
keep the USB interface active. Maybe others who know more will chime in
and explain.
> 
> Ross

Cheers,
Wol
