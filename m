From: bfowler@ewitness.co.uk (ewitness - Ben Fowler)
Subject: Re: RAID 5 disk format for Promise SuperTrak Sx6000 (Linux)
Date: Sun, 26 May 2002 20:01:37 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <f04330105b916dfd66f7e@[192.168.254.56]>
References: <f04330107b915ec475e78@[192.168.254.56]>
 <001801c204e5$1daf12f0$0505a8c0@PLUTO>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001801c204e5$1daf12f0$0505a8c0@PLUTO>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 11:42 am -0700 26/5/02, 3tcdgwg3 wrote:
>Ben,
>
>If I understand you correctly - you are trying to use
>Linux RAID (which is a self contained software system),
>to read the disk information written by the IBM/Mylex
>controller (which is proprietary hardware RAID system
>deveoped by IBM/Mylex), instead of using IBM/Mylex
>controller - there is no easy way to do that, unless you 
>know the IBM/Mylex RAID firmware and data structures.

You are definitely on the right lines. I am trying to read
RAID data structures written by a hardware RAID controller,
with Linux software RAID.

The Promise SuperTrak Sx6000 is the card in question.

I mention the Mylex, because someone else has done it,
which confirms the possibility.

I am grateful for your comments. So far I have not
heard of any direct way of doing what I want, but i
have had some excellent advice from the list, and
the outcome, whilst is dubious character, is far, far
better than it first appeared.

Ben.
