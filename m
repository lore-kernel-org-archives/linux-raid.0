From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Alex Samad Re: RAID5 (mdadm) array hosed after grow operation
Date: Fri, 09 Jan 2009 10:45:56 +0000
Message-ID: <49672AE4.2060602@anonymous.org.uk>
References: <1231144738.2997.1293010001@webmail.messagingengine.com> <alpine.DEB.1.10.0901050913470.3359@p34.internal.lan> <18786.34570.756734.253596@notabene.brown> <1231388345.19357.1293603883@webmail.messagingengine.com> <20090108101218.GI25654@samad.com.au> <1231468886.24549.1293797183@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1231468886.24549.1293797183@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: whollygoat@letterboxes.org
Cc: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/01/2009 02:41, whollygoat@letterboxes.org wrote:
> But anyway, I don't think that is going to matter.  The issue I am
> trying to 
> solve is how to de-activate the bitmap. It was suggested on the
> linux-raid 
> list that my problem may have been caused by running the grow op on an
> active 
> bitmap and I can't see from "man mdadm" how to de-activate the bit map.

man mdadm tells me:
[...]
-b, --bitmap=
     Specify a file to store a write-intent bitmap in. The file should 
not exist unless --force is also given. The same file should be provided 
when assembling the array. If the word internal is given, then the 
bitmap is stored with the metadata on the array, and so is replicated on 
all devices. If the word none is given with --grow mode, then any bitmap 
that is present is removed.

So I imagine you'd want to
   # mdadm --grow /dev/mdX --bitmap=none
to de-activate the bitmap.

Cheers,

John.

