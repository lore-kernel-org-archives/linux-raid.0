From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Big-endian RAID5 recovery problem
Date: Mon, 1 May 2017 22:59:14 +0100
Message-ID: <0ab1ea1b-8035-512e-0b0a-819e15929f41@youngman.org.uk>
References: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Thompson <athompso@athompso.net>, MUUG Roundtable <roundtable@muug.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/05/17 22:39, Adam Thompson wrote:

>
> I'm reluctant to blindly do a forced --create on the four disks, because
> I'm not 100% certain of the RAID topology; there are at least two RAID
> devices, one of which was hidden from the user, so I have no a-priori
> knowledge of its RAID level or layout.
>
Get hold of lsdrv, and see what that tells you. (Look at the raid wiki 
for details.) I don't know if it will have endian issues, but if it 
doesn't an expert will probably be able to chime straight in and tell 
you the create command.

The other thing is, read up on overlays because, if you overlay those 
disks, you will be able to "create" without actually writing to the 
disks. That way you can test - and even do a complete backup and 
recovery - without ever actually writing to, and altering, the original 
disks.

Cheers,
Wol
