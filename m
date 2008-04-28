From: Keith Roberts <keith@karsites.net>
Subject: RE: mdadm crashing server?
Date: Mon, 28 Apr 2008 11:50:53 +0100 (BST)
Message-ID: <alpine.LFD.1.10.0804281144510.10768@www.karsites.net>
References: <00c801c8a8e8$a1dc5670$0405a8c0@hp>,
	<alpine.LFD.1.10.0804280619240.5431@www.karsites.net>
	<23803AB141208D42AD050BF05F9EFB6A31EE160DCE@londondc02.an0key.net>
Reply-To: Keith Roberts <keith@karsites.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23803AB141208D42AD050BF05F9EFB6A31EE160DCE@londondc02.an0key.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 28 Apr 2008, Luke Sheldrick wrote:

> To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
> From: Luke Sheldrick <luke@sheldrick.co.uk>
> Subject: RE: mdadm crashing server?
> 
>
>> From the Linux software raid howto: It is not recommended to
>> run the same RAID1 array on the same IDE cable as
>> master/slave. In fact the howto recommends 1 drive set as
>> master on one cable only. One reason being if your master
>> drive goes down, then the slave may not operate correctly.
>
>
> I was think it probably wasn't a good idea.
>
> I changed over one of the disc's from the array, to sit on 
> the secondary IDE. It seems to now die at 1% and reset the 
> sync (not killing the machine this time however)
*snip*
> hex): Apr 28 09:27:09 nas kernel:  72 03 11 04 00 00 00 0c 
> 00 0a 80 00 00 00 00 00 Apr 28 09:27:09 nas kernel:  00 94 
> 61 80 Apr 28 09:27:09 nas kernel: sd 3:0:1:0: [sdf] Add. 
> Sense: Unrecovered read error - auto reallocate failed Apr 
> 28 09:27:09 nas kernel: end_request: I/O error, dev sdf, 
> sector 9724288 Apr 28 09:27:09 nas kernel: ata4: EH 
> complete Apr 28 09:27:09 nas kernel: raid1: sdf: 
> unrecoverable I/O read error for block 9722240 Apr 28

Maybe you need to run smartmontools on the disk.

I think auto reallocate failure is a smart disk attribute.

Also the disks seem to be running at different DMA speeds. 
Do they need setting to the same speeds or not?

Kind Regards

Keith Roberts

-----------------------------------------------------------------
Websites:
http://www.php-debuggers.net
http://www.karsites.net
http://www.raised-from-the-dead.org.uk

All email addresses are challenge-response protected with 
TMDA [http://tmda.net] 
-----------------------------------------------------------------
