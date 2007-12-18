From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RE: Raid over 48 disks
Date: Tue, 18 Dec 2007 18:59:23 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712181859040.13735@p34.internal.lan>
References: <200712182350.lBINoMn17765@www.watkins-home.com>
 <Pine.LNX.4.64.0712181858200.13735@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712181858200.13735@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'Brendan Conoboy' <blc@redhat.com>, 'Norman Elton' <normelton@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 18 Dec 2007, Justin Piszcz wrote:

>
>
> On Tue, 18 Dec 2007, Guy Watkins wrote:
>
>> } -----Original Message-----
>> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> } owner@vger.kernel.org] On Behalf Of Brendan Conoboy
>> } Sent: Tuesday, December 18, 2007 3:36 PM
>> } To: Norman Elton
>> } Cc: linux-raid@vger.kernel.org
>> } Subject: Re: Raid over 48 disks
>> }
>> } Norman Elton wrote:
>> } > We're investigating the possibility of running Linux (RHEL) on top of
>> } > Sun's X4500 Thumper box:
>> } >
>> } > http://www.sun.com/servers/x64/x4500/
>> }
>> } Neat- 6 8 port SATA controllers!  It'll be worth checking to be sure
>> } each controller has equal bandwidth.  If some controllers are on slower
>> } buses than others you may want to consider that and balance the md
>> } device layout.
>> 
>> Assuming the 6 controllers are equal, I would make 3 16 disk RAID6 arrays
>> using 2 disks from each controller.  That way any 1 controller can fail and
>> your system will still be running.  6 disks will be used for redundancy.
>> 
>> Or 6 8 disk RAID6 arrays using 1 disk from each controller).  That way any 
>> 2
>> controllers can fail and your system will still be running.  12 disks will
>> be used for redundancy.  Might be too excessive!
>> 
>> Combine them into a RAID0 array.
>> 
>> Guy
>> 
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>
> I'd be curious what the maximum aggregate bandwidth would be with RAID 0 of 
> 48 disks on that controller..
>

A RAID 0 over all of the controllers rather, if possible..


