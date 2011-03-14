From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: Q: imsm rapid recovery volume
Date: Mon, 14 Mar 2011 08:28:05 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D5048844B742@azsmsx504.amr.corp.intel.com>
References: <20110314105626.GA19922@maude.comedia.it>
 <AANLkTinzwY7CgOE2gjBUsBgKT0MTREgeYZXFDLf3BPEz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinzwY7CgOE2gjBUsBgKT0MTREgeYZXFDLf3BPEz@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: Luca Berra <bluca@comedia.it>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Roberto Spadim
> Sent: Monday, March 14, 2011 7:08 AM
> To: linux-raid@vger.kernel.org
> Cc: Luca Berra
> Subject: Re: Q: imsm rapid recovery volume
> 
> how it works on linux? it's a block device for linux? like: /dev/sda?
> if yes, i don't see problems using it with mdadm (software raid). but i think
> that it's a intel hardware raid, i'm right?
> 
> 2011/3/14 Luca Berra <bluca@comedia.it>:
> > Hello,
> > i got hold of a new laptop that supports Intel Rapid Recover
> > Technology http://www.intel.com/support/chipsets/imsm/sb/cs-
> 026142.htm
> > it sounds cool,
> > does this feature work with mdadm?
> >
> > Thanks in advance and regards,
> > L.
> >
> > --
> > Luca Berra -- bluca@comedia.it

No this is Intel BIOS RAID. You need a kernel that's fairly recent and mdadm that supports external metadata so once again something fairly recent. Fedora supports this out of box if you want a free distro. Ubuntu does not last time I checked because grub2 doesn't seem to work properly yet with IMSM, but I know they are putting in new code to support it. 

I have updated the RAID wiki. Please take a look here:
https://raid.wiki.kernel.org/index.php/RAID_setup#External_Metadata

