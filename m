From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: with raid-6 any writes access all disks
Date: Tue, 01 Nov 2011 15:22:44 -0700
Message-ID: <4EB07134.9080308@zytor.com>
References: <CAGtzr3c65BXDfWZq4ejKwCZv7hPZmdCpvQP17RgFS-Vrn2YF5Q@mail.gmail.com> <20111027082331.01e1fc7a@notabene.brown> <4EA889FF.90002@zytor.com> <4EA92493.1060107@westcontrol.com> <4EA94D1F.8080507@zytor.com> <4EA956FE.3070504@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EA956FE.3070504@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: NeilBrown <neilb@suse.de>, Chris Pearson <kermit4@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/27/2011 06:05 AM, David Brown wrote:
> 
> Where does it go wrong?  Is it the automatic vectorisation with SSE,
> etc., that is still too limited with gcc?  I have done very little work
> with x86/amd64 assembly (most of my experience is with microcontrollers
> rather than "big" processors), so I haven't tried looking at gcc's SSE
> code and comparing it to hand-optimised code.
> 

The autovectorization isn't good enough to understand the tricks that
are necessary to get good performance.  They require leaning pretty hard
on the instruction set.

	-hpa

