From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm 3.0.2 won't read mdadm.conf file
Date: Mon, 28 Sep 2009 18:30:35 +0100
Message-ID: <4AC0F2BB.60101@anonymous.org.uk>
References: <1e36c70e0909280013o616d74draf419a548183cc7f@mail.gmail.com>	 <73e903670909280218t44e1ddb0u8117ea4611643883@mail.gmail.com>	 <1e36c70e0909280536s513fa655n9533efe220dceddf@mail.gmail.com>	 <73e903670909280553t3de93c68t5673ba234ac72bef@mail.gmail.com>	 <1e36c70e0909280652j42ee420mabaa4141363a976a@mail.gmail.com>	 <73e903670909280704r1189e86aoc08cbc260e6d8ab8@mail.gmail.com>	 <1e36c70e0909280714r2d81238dq198699a863be359e@mail.gmail.com>	 <1e36c70e0909280748m160c190an453de1a773a96c48@mail.gmail.com>	 <70ed7c3e0909280932h326730c4u2606044bbc6bce06@mail.gmail.com> <1e36c70e0909280950o731c59a8t5f43b0d16382edc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1e36c70e0909280950o731c59a8t5f43b0d16382edc5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aggelos Kyritsis <filodoksos@gmail.com>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/09/2009 17:50, Aggelos Kyritsis wrote:
[re-ordered for clarity]
> On Mon, Sep 28, 2009 at 7:32 PM, Majed B. <majedb@gmail.com> wrote:
>> Did you update initramfs after installing mdadm 3.0.2?
> Yes, it was one of the first things I tried, as advised by
> Kristleifur, and it didn't work.

I don't know Ubuntu at all but I bet its mdadm package adds some bits so 
mdadm and md RAID modules can get automatically included in the 
initramfs, while installing by hand won't. You could probably have 
reconfigured the initramfs generator on Ubuntu to do it, though.

Cheers,

John.
