From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 18:40:31 -0900 (AKST)
Message-ID: <alpine.LNX.2.01.1002141839210.12929@filesrv1.baby-dragons.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan> <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com> <4B77044B.1020609@zytor.com> <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan> <4B7719C1.1060400@zytor.com>
 <4B785C49.7010105@shiftmail.org> <4B786898.8030309@zytor.com> <4B788525.6000608@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B788525.6000608@grumpydevil.homelinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Asdo <asdo@shiftmail.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

 	Hello All ,

On Mon, 15 Feb 2010, Rudy Zijlstra wrote:
> H. Peter Anvin wrote:
>> In Fedora 12, for example, Dracut tries to make the distinction between
>> whole RAID device and a partition device, and utterly fails -- often
>> resulting in data loss.
>> 
> i do not use Fedora/redhat and do not intent to ever try them again... still, 
> the point is valid
>> With a pointer to the beginning this would have been a trivial thing to
>> detect.
>> 
>> IMO it would make sense to support autoassemble for 1.0 superblocks, and
>> making them the default.  The purpose would be to get everyone off 0.9.
>>  However, *any* default is better than 1.1.
>> 	-hpa
> As long is autodetect is supported in the kernel, i am willing to upgrade to 
> 1.0 superblocks. BUT i need the autodetect in the kernel, as i refuse to use 
> initrd for production servers.
> Cheers,
> Rudy
 	I also have to agree with Rudy in this matter .

 		Tia ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
