From: "Filipe Maia" <fmaia@gmx.net>
Subject: Re: proactive raid5 related bug2
Date: Thu, 12 Jan 2006 20:06:18 +0100
Message-ID: <op.s294osbki22er4@xray.bmc.uu.se>
References: <op.s29xuno5i22er4@xray.bmc.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s29xuno5i22er4@xray.bmc.uu.se>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 12 Jan 2006 17:38:37 +0100, Filipe Maia <fmaia@gmx.net> wrote:

> Another CPU lockup this time due to read persistent errors while  
> building the array.
> I have a script with which i can reproduce the bug and another one which  
> simply removes
> the read persistent errors that already works correctly.
> Kernel is 2.6.14 with proactive patch.
> I'm not sure what are the practical implications of this bug (meaning if  
> it actually
> happens in real use).
> I have 16 ram disks with 8MB each.
>
>

Even in the standard kernel this basically locks up the machine, in an  
infinite
loop although there is no real freeze.



-- 
All generalizations are false, including this one.
          -- Mark Twain
