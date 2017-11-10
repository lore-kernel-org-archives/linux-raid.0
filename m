From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 up, but one drive removed, one says spare building, what
 now?
Date: Fri, 10 Nov 2017 13:01:50 -0500
Message-ID: <3fa05723-8275-8840-7fbc-397801fa17de@turmel.org>
References: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
 <5A058E25.1020608@youngman.org.uk>
 <34b72bc9-9a72-3143-bd1e-d00f90493d04@turmel.org>
 <CAK2H+ec6DxBE_Mxq9skOa3XNGMc2BW8Q4+ieoA13uG+UhE4nZg@mail.gmail.com>
 <CAA4aoFbOnCtj_+qbfuzz7qS6xrt5HB9XJK-E+h0_eEu=vLdftg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA4aoFbOnCtj_+qbfuzz7qS6xrt5HB9XJK-E+h0_eEu=vLdftg@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Jun-Kai Teoh <kai.teoh@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Jun-Kai,

{Convention on kernel.org is to trim replies and avoid top-posting.}

On 11/10/2017 12:25 PM, Jun-Kai Teoh wrote:
> I was reshaping/growing my array when it died. Computer came back up
> but array wouldn't assemble.
> 
> I looked around and saw some commands on how to assemble without the
> one drive that looked like it was kicked off sometime ago that I did
> not realize (I used --assemble --force --verbose)
> 
> I kept getting the error that there were 6 drives, 1 rebuilding, and
> not enough to get the array up. I unplugged the one drive that had the
> incorrect superblock and ran "mdadm -A -R".
> 
> It ran and looked like it was resuming reshaping but it got really
> slow - like 7 years slow.
> 
> I killed the process, rebooted the machine, and it just auto
> reassembled the array and automounted it on boot.
> 
> Am in the process of backup right now.
> 
> And yes, the drive/array is mounted.

Ok.  I reviewed the other thread.  Consider creating a new array from
scratch after you complete your backups, using consistent partitioning
across all devices.  I would put LVM on top and leave part of it
unallocated (for emergencies), but that's just my preference.

Phil



