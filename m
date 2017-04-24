From: Phil Turmel <philip@turmel.org>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 17:04:39 -0400
Message-ID: <09feff90-bb2b-7e27-599e-40284ca004ae@turmel.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <20170423104606.GA4603@metamorpher.de>
 <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
 <58FC91B8.5090603@youngman.org.uk> <20170423165810.75b5836e@natsu>
 <58FC99ED.7080705@youngman.org.uk>
 <e4c2acc6-420a-e454-fe74-c82737a1bbf0@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e4c2acc6-420a-e454-fe74-c82737a1bbf0@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>, Wols Lists <antlists@youngman.org.uk>, Roman Mamedov <rm@romanrm.net>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/23/2017 08:15 AM, Patrik Dahlström wrote:
> 
> 
> On 04/23/2017 02:11 PM, Wols Lists wrote:
>> On 23/04/17 12:58, Roman Mamedov wrote:
>>> On Sun, 23 Apr 2017 12:36:24 +0100
>>> Wols Lists <antlists@youngman.org.uk> wrote:
>>>
>>>> And, as the raid wiki tells you, download lspci and run that
>>>
>>> Maybe you meant lsdrv. https://github.com/pturmel/lsdrv
>>>
>> Sorry, yes I did ... (too many ls_xxx commands :-)
> Ok, I had to patch lsdrv a bit to make it run. Diff:

Thanks for the patch.  Could you elaborate a bit on the errors you
received so I can reproduce and document this fully?

Also, do you have some large files (media files, perhaps) that you know
are in your array but you have a copy in hand?  If so, you could use the
findHash script in my github account to map how that file is laid out on
your array's devices.  Since large media files tend to be contiguous,
such a map would definitively show your chunk size and device order.

It would also show if your data offsets are consistent among the member
drives (but not the absolute value of the offset).

Phil


