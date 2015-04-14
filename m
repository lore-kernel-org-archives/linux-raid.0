From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Recovery Raid6 Degraded
Date: Tue, 14 Apr 2015 16:19:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1504141617220.16871@uplift.swm.pp.se>
References: <CACsoFmjWW7mqSA8OKZZEPhpFidf-exSMm771ZOp0TssSYydcrw@mail.gmail.com> <alpine.DEB.2.02.1504132234220.16871@uplift.swm.pp.se> <CACsoFmiCXw1dgpqtz33rA5ejMhYsndi68L63OdpRoU_XyCfFFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsoFmiCXw1dgpqtz33rA5ejMhYsndi68L63OdpRoU_XyCfFFg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emanuel Domingos <emanuelsdrock@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 14 Apr 2015, Emanuel Domingos wrote:

> Hi, Mikael, hi guys!
>
>
> Follow the errors found after building the new version of mdadm:
>
> #mdadm --stop /dev/md/ubuntu\:md-raid6_primary
>
> #mdadm --assemble --force /dev/md/ubuntu\:md-raid6_primary /dev/sdaa /dev/sdac
> /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdz
>
> mdadm: device /dev/md/ubuntu:md-raid6_primary exists but is not an md array.

Please call it /dev/md124 and not the above ubuntu: name. I have no idea 
what it is you're trying to do with that name. Also use --verbose when 
trying to do the assembly and see if you get any further information.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
