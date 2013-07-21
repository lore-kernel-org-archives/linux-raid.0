From: Martin Wilck <mwilck@arcor.de>
Subject: Re: How does md(adm) work with fake-raid ?
Date: Sun, 21 Jul 2013 19:10:23 +0200
Message-ID: <51EC15FF.1070809@arcor.de>
References: <CAC9WiBjU_A0jsB4KoX4B9ohT4TD3cYuDdioM6hSWfK13Otjs-Q@mail.gmail.com>	<51E86613.9050505@arcor.de>	<CAC9WiBiup8RfusZo51DjAsTOLyr1F-LxgGGCWRCakYURskz7rA@mail.gmail.com>	<51E98AEF.5060206@arcor.de> <CAC9WiBhBEjcWFkX5g_hBfAMjs_cD5iK1MTn=w=MdXRBykY+rAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBhBEjcWFkX5g_hBfAMjs_cD5iK1MTn=w=MdXRBykY+rAg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/21/2013 03:41 PM, Francis Moreau wrote:
> On Fri, Jul 19, 2013 at 8:52 PM, Martin Wilck <mwilck@arcor.de> wrote:
>>> Yes, but my question is about how md cooperate with the BIOS in this case ?
>>
>> Not sure what you mean. When Linux runs, with or without MD, no BIOS
>> code is ever executed.
> 
> Ok I think I'm missing something more fundamental here.
> 
> For exemple when writing to the disk, each write goes into the 2 disks
> in case of RAID1. When Linux runs, is it either DM or MD (and
> necessarily one of them) that does this work ?

Yes.

> For windows case, does it relies on a driver that is provided by the
> RAID manufacturer ?

Exactly.

Regards
Martin
