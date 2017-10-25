From: Phil Turmel <philip@turmel.org>
Subject: Re: Kernel preventing (extra) spare disk in array from entering
 standby
Date: Wed, 25 Oct 2017 13:52:12 -0400
Message-ID: <9cfd5889-53aa-a55b-7615-c90c58c3c766@turmel.org>
References: <CAJO99TkXsobN3EszoPM37y=Eth-URQeLTSd8fBDpATHg1x-tmQ@mail.gmail.com>
 <f656c779-f376-82a2-cf2f-769767b478d6@turmel.org>
 <CAJO99Tn=1TRahO1gH4KW-8=g4rdf4PaCbPMbR3a6Ui1c_i3QuQ@mail.gmail.com>
 <5aac3242-723f-fce9-a438-1ca95f5d4d50@turmel.org>
 <CAJO99Tm9_j-rN+B4iTE2KpvqkHG5V07DB=TqK6Mh9=Jof7_MhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJO99Tm9_j-rN+B4iTE2KpvqkHG5V07DB=TqK6Mh9=Jof7_MhA@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Bj=c3=b8rnar_Ness?= <bjornar.ness@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/25/2017 01:13 PM, Bjørnar Ness wrote:

> I am not asking for _A_ way to solve this, lets try to stick to the problem
> reported: md writing to inactive spares on rebuild.

I gave the most likely reason in my first reply.  All member devices,
including spares, carry array metadata in their superblock.  That
metadata includes event counts and rebuild progress information that MD
will need to safely continue if your system crashes in the middle of
that operation.

If you strongly believe that shouldn't be the case, you'll need to
prepare a patch that changes the behavior, post the patch on this list
for review, and convince the maintainers that you're right and that your
patch is well-formed.

Part of your argument will undoubtedly have to be *why* this case needs
special handling in the kernel when the obvious (userspace) solution is
to not attach excessive numbers of spares.

Phil
