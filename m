From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: Need Help with crashed RAID5 (that was rebuilding and then had
 SATA error on another drive)
Date: Sun, 28 Aug 2016 20:25:09 -0500
Message-ID: <57C38EF5.7020005@gmail.com>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <215fd175-65b6-e24b-338f-0c44ae030573@websitemanagers.com.au>
 <CADDTLRBf9NPO6OuF4a3b+xffZgeZRqHRG+pJdPmbc9-Jat0HVQ@mail.gmail.com>
 <d6d3fe0d-3f9f-985f-9bfb-051428cf221b@websitemanagers.com.au>
 <57BBDA5B.3020706@gmail.com> <57BBDC15.5030301@gmail.com>
 <b8c6a380-7e6a-fda9-5834-b85271b26892@websitemanagers.com.au>
 <57BC61F7.8070102@gmail.com>
 <aca4e83f-9a3f-c200-7c16-3b5d9df52c1e@websitemanagers.com.au>
 <57BE450B.4030700@gmail.com>
 <56e86db5-456d-e9c1-339d-ba8903fe5dde@websitemanagers.com.au>
 <57BE52BC.6040908@gmail.com>
 <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
 <57BF9965.1020403@gmail.com> <57C0856D.8050209@youngman.org.uk>
 <57C32D8E.9030102@gmail.com>
 <3b008fb0-1fb3-f12f-d973-3657de6e6923@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3b008fb0-1fb3-f12f-d973-3657de6e6923@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/28/2016 06:54 PM, Adam Goryachev wrote:
> When I saw this, I assume it means you can ask for the status, and it will tell you it is disabled, but there is no support to modify the status (ie, turn it on). Totally useless for all intents and purposes....
>
> Then again, I could be wrong... but compared to your other drive which showed additional supports, or on my one here:
> SCT capabilities:              (0x0039) SCT Status supported.
>                                         SCT Error Recovery Control supported.
>                                         SCT Feature Control supported.
>                                         SCT Data Table supported.
>
> ie, the second one is probably what you want, the third allows you to turn it on/off, and no idea about the last option....
>


Right - I get that. But not knowing *for sure* I thought I would go look it up and google wasn't exactly helpful for a developer style description of what exactly the difference was.

again, no worries. I'll get me some of the right drives one way or another.

 -Ben

