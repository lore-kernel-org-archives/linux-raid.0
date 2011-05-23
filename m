From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 11:44:54 +0100
Message-ID: <4DDA3AA6.3070004@anonymous.org.uk>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <BANLkTi=az3ny5m7Mf20t5fnFj79CsowJWg@mail.gmail.com> <4DD97C83.4050907@truschnigg.info> <4DDA2D77.1050604@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDA2D77.1050604@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/05/2011 10:48, Ed W wrote:
[...]
> Pardon what is probably a very ignorant question, but someone earlier in
> this thread claimed that some adaptors report the size of the disk
> slightly differently?  Wouldn't this potentially cause problems if you
> needed to move the disks to a different controller?

Yup. RAID cards will use some of the disc for their own metadata. The 
amount used, and the location of it, is probably different for different 
controllers. This would be one reason why using a RAID controller with 
BBWC and exporting the drives as single-drive RAID0 volumes is a bit 
icky, and liable to tie you to one manufacturer.

There is a possibility (handwaving here) that using a RAID controller in 
JBOD mode would be similar. You may need to flash your controller to 
non-RAID firmware to avoid it, at which point you probably ought to have 
bought an HBA in the first place.

There is a similar problem on some OEMs' BIOSes that will set a 
"host-protected area" that will reduce the visible size of drives.

> Additionally if you needed to replace the disk then some new batch might
> be some few sectors smaller?  This seems to be the biggest reason for
> wanting to add a partition table and then deliberately partition some
> 10s MB smaller? (Think I saw this exact problem come up several times in
> the last few weeks alone?)

For spinning rust discs this hasn't been the case for several years 
since we passed about 160GB; all the manufacturers signed up to an 
industry standard[1] making all their discs a consistent number of 
sectors for any given marketing size.

It's probably a problem again now with SSDs, though.

Cheers,

John.

[1] I can't remember what the standard or standards group is, and I 
can't be bothered looking it up. But of course it's a standard. We love 
standards, that's why we have so many of them![2]

[2] Sorry if I'm a bit grumpy this morning. Too many standards and not 
enough coffee make John a grumpy boy.

