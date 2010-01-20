From: Brett Russ <bruss@netezza.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 20 Jan 2010 17:25:47 -0500
Message-ID: <hj7vta$nvq$1@ger.gmane.org>
References: <387070.15704.qm@web51305.mail.re2.yahoo.com> <hj77p7$rsr$1@ger.gmane.org> <70ed7c3e1001201244k3c734336y8e145bb50f88de26@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1001201244k3c734336y8e145bb50f88de26@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/20/2010 03:44 PM, Majed B. wrote:
> You can find details on these parameters and their values in md's
> documentation: http://www.mjmwired.net/kernel/Documentation/md.txt
>
> A mismatch count can be checked by writing "check" to the proper file
> as stated in line 376:
> http://www.mjmwired.net/kernel/Documentation/md.txt#376

Sounds like Jon may have a flaky HDD if certain members continually 
throw errors.  Jon, can you check SMART stats on your drives?

for di in a b c d e f g; do smartctl -a /dev/sd$di | grep -i _sect; done

you may have to add another option to smartctl, I forget.

-BR

