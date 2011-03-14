From: Luca Berra <bluca@comedia.it>
Subject: Re: Q: imsm rapid recovery volume
Date: Mon, 14 Mar 2011 20:18:03 +0100
Message-ID: <20110314191803.GA24188@maude.comedia.it>
References: <20110314105626.GA19922@maude.comedia.it> <AANLkTinzwY7CgOE2gjBUsBgKT0MTREgeYZXFDLf3BPEz@mail.gmail.com> <D010E79907AF0D4E90B603DE907837D5048844B742@azsmsx504.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D010E79907AF0D4E90B603DE907837D5048844B742@azsmsx504.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 14, 2011 at 08:28:05AM -0700, Jiang, Dave wrote:
>No this is Intel BIOS RAID. You need a kernel that's fairly recent and mdadm that supports external metadata so once again something fairly recent. Fedora supports this out of box if you want a free distro. Ubuntu does not last time I checked because grub2 doesn't seem to work properly yet with IMSM, but I know they are putting in new code to support it. 
>
>I have updated the RAID wiki. Please take a look here:
>https://raid.wiki.kernel.org/index.php/RAID_setup#External_Metadata
>
Dave,
There does not seem to be any information regarding rapid recovery on
the wiki.
Are you implying it just works?
I tried to set one up under windows with continuous update policy, but
when i rebooted under linux it looked like the recovery disk was failed.
I am usink kernel 2.6.36.2 and mdadm 3.1.2, raid1 on a similar config
was working correctly.

Thanks in advance and regards,
L.

-- 
Luca Berra -- bluca@comedia.it
