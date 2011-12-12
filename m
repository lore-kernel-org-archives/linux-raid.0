From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Mon, 12 Dec 2011 15:33:02 +0000
Message-ID: <4EE61EAE.20101@anonymous.org.uk>
References: <20111212115459.GC20730@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111212115459.GC20730@fi.muni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/12/2011 11:54, Jan Kasprzak wrote:
> 	Hello, Linux RAID gurus,
>
> I have a new server with two identical external disk shelves (22 drives each),
> which will be connected to the server with a pair of SAS cables.
> I want to use RAID-10 on these disks, but I want it to be configured
> so that the data will always be mirrored between the shelves.
> I.e. I want to be able to overcome complete failure of a single shelf.
>
> 	Is there any way how to tell mdadm explicitly how to set up
> the pairs of mirrored drives inside a RAID-10 volume?

If you're using RAID10,n2 (the default layout) then adjacent pairs of 
drives in the create command will be mirrors, so your command line 
should be something like:

# mdadm --create /dev/mdX -l10 -pn2 -n44 /dev/shelf1drive1 
/dev/shelf2drive1 /dev/shelf1drive2 ...

Having said that, if you think there's a real chance of a shelf failing, 
you probably ought to think about adding more redundancy within the 
shelves so that you can survive another drive failure or two while 
you're running on just one shelf.

If you are sticking with RAID10, you can potentially get double the read 
performance using the far layout - -pf2 - and with the same order of 
drives you can still survive a shelf failure, though your use of port 
multipliers may well limit your performance anyway.

Hope this helps!

Cheers,

John.

