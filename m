From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] "--assemble --scan" support for imsm
Date: Wed, 05 Nov 2008 08:40:13 -0700
Message-ID: <4911BE5D.2060605@intel.com>
References: <1225230241.5778.26.camel@dwillia2-linux.ch.intel.com>	<18696.10925.969583.445231@notabene.brown>	<e9c3a7c20810290912k6530790dv5cf7f6db8ff40389@mail.gmail.com>	<18697.11562.810718.957829@notabene.brown>	<1225667752.14396.22.camel@dwillia2-linux.ch.intel.com> <18704.10588.526784.38341@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18704.10588.526784.38341@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> I haven't included your
> 
>    Let symlinks to standard devices count as standard names
> 
> patch because I don't think I agree with it, and I don't think it is
> needed any more.
> 

My concern was that:
for i in `seq 1 5`
do
	mdadm -As
	mdadm -Ss
done

...would create 5 different device numbers.  Your right it is better 
now, but between successive assemblies the device numbers still toggle 
between two different values.  So it's just a small cosmetic issue now. 
  Are their lifetime issues that preclude predictable device numbers?

> I also have left out your
> 
>      imsm: match_home(), document why it is stubbed out
>     
> because I don't understand.  Maybe some more words about how
> 'family_num' can distinguish between "Local" and "Foreign". ??
> 

...it doesn't.  'family_num' is a checksum that includes the serial 
numbers of the component disks when the array was first created.  So it 
can help determine when two arrays were created in different places, but 
the metadata can't identify which, if any, is "Local".

I'll redo the comment.

Thanks for the pull and the review,
Dan
