From: "Robin Bowes" <robin@robinbowes.com>
Subject: RE: Add disks to RAID5 array
Date: Thu, 22 Jul 2004 19:51:38 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S266903AbUGVSvk/20040722185140Z+2514@vger.kernel.org>
References: <002f01c4701a$5712b180$0201a8c0@windows>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002f01c4701a$5712b180$0201a8c0@windows>
To: 'TJ Harrell' <systemloc@earthlink.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of TJ Harrell
> Sent: 22 July 2004 18:33
> To: linux-raid@vger.kernel.org
> Subject: Re: Add disks to RAID5 array
> 
> I've used raidreconf to convert from RAID 1 to RAID 5 and to 
> grow RAID 5 arrays. I would recommend a UPS. If the power 
> blips, the array will be lost.
> Other then that, I've never had any trouble whatsoever with 
> it. IMO, resize2fs is more dangerous than using raidreconf. I 
> have had resize2fs corrupt file systems badly before. It's 
> important to run fsck -f both before and after resize2fs. It 
> catches a lot of minor, fixable problems after the resize2fs 
> is run. Doing this, I have successfully grown RAID 5 arrays 
> many times without any trouble.
> 
> In any case, backing up is highly recommended if you value the data!

TJ,

I didn't say, but I've been using mdadm to create/manage my RAID so far. Do
you know if it's possible to achieve this using just mdadm?

That actually prompts me to ask another question...which I'll save for
another thread!

R.
--
http://robinbowes.com  

