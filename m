From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: WD nas broke can't accessmy files on RAID 1
Date: Sat, 21 Oct 2017 17:11:19 +0100
Message-ID: <733072ab-9ce6-e68c-6652-09d75c8cf284@youngman.org.uk>
References: <CAKNaYNuY8gNn+u4uMK8U+AnnYMmH8GNPDJGWTG1SNrQpDG4kjA@mail.gmail.com>
 <bfbf59c2-c750-f87b-5167-37c84086bb75@youngman.org.uk>
 <CAKNaYNtK+-1JXmLQk0zcX1HrAiczVAoFCKTmJQuG5FexxwRGPg@mail.gmail.com>
 <CAKNaYNusb-iQN3V4an8Hs_s+gD4m_n4yC1o2=VxY081-T+SHNQ@mail.gmail.com>
 <001ecd43-c770-4abe-5ded-57377c843d5d@youngman.org.uk>
 <CAKNaYNugRX-kRZOLdE57gFnPyuLgDtVMbPp5qk_2CzZdUJqW4g@mail.gmail.com>
 <CAKNaYNv0YXqMTN-1PGBpPYgQJ-5VLovhmLgA0WiR6T2Webj2mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKNaYNv0YXqMTN-1PGBpPYgQJ-5VLovhmLgA0WiR6T2Webj2mw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Francesco Tomadin <inamaru94@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/10/17 16:43, Francesco Tomadin wrote:
> Thanks to a guy on IRC after some check he told me to use
> 
> mdadm --assemble --scan
> and IT worked! I can access again my drive!
> 
> Thanks for everythiing!

Do still do that "smartctl -x"! If your NAS dos have the wrong sort of 
drives in it, this is just going to happen again ... If it comes back 
and says SCT/ERC *is* supported, then your disks are good and you're fine.

Cheers,
Wol
