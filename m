From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID5 up, but one drive removed, one says spare building, what now?
Date: Fri, 10 Nov 2017 06:13:20 -0700
Message-ID: <CAK2H+ec6DxBE_Mxq9skOa3XNGMc2BW8Q4+ieoA13uG+UhE4nZg@mail.gmail.com>
References: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
 <5A058E25.1020608@youngman.org.uk> <34b72bc9-9a72-3143-bd1e-d00f90493d04@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <34b72bc9-9a72-3143-bd1e-d00f90493d04@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, Jun-Kai Teoh <kai.teoh@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Nov 10, 2017 at 6:01 AM, Phil Turmel <philip@turmel.org> wrote:
> Hi Jun-Kai,
>
> On 11/10/2017 06:31 AM, Wols Lists wrote:
>> On 10/11/17 03:09, Jun-Kai Teoh wrote:
>>> Hi all,
>>>
>>> I managed to get my RAID drive back up, content looks like it's still
>>> there, but it's not resyncing or reshaping and my parity drive was
>>> removed (I did it when I tried to get it back up).
>
> If you can see your content (mounted read-only, I hope), backup up
> everything, in order from most critical to least critical.
>
>>> So what should I do now? I'm afraid of doing anything else at this point.
>
> Well, you need to provide more information.  At least the mdadm -E
> reports for all of the member devices.  Including the "parity" device
> you removed.  (Parity is spread among all devices in a normal raid5
> layout, so you may be suffering from a misunderstanding.)
>

Phil,
   Please reference the thread entitled

"Raid 5 array down/missing - went through wiki steps"

All the mdadm -E info and much more was reported there a week
ago. Wols and I helped get him that far but neither of us was confident
in giving instructions to get him further.

Cheers,
Mark
