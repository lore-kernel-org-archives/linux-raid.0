From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 reconstruction ?
Date: Sat, 30 May 2009 14:35:14 +0100
Message-ID: <4A213612.7080206@anonymous.org.uk>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/05/2009 06:44, SandeepKsinha wrote:
> Hi all,
> 
> Say If I have a RAID 5 array of 50GB of five disks of 10GB each.
> 
> I have data of 5GB. When a disk fails and replaced with a spare disk.
> Will the reconstruction happen only for the 5GB allocated disk blocks
> or it will happen for the whole disk size.

The whole disc size, for now anyway; md does not currently note which 
blocks have been used by its client (the filesystem, LVM, whatever).

> Is it possible to make  reconstruction intelligent enough to keep it optimized ?

This has been discussed in combination with supporting SSD drives' TRIM 
function, and would mean md had to keep track of used chunks or possibly 
even sectors using a bitmap or something like that, but whether anyone's 
working on it I don't know.

Cheers,

John.

