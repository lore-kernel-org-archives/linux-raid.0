From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 12:01:41 -0700
Message-ID: <m2x5bdc1c8b1004211201ob1ea0c67k67b03eb4627a1375@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com>
	 <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com>
	 <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net>
	 <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com>
	 <4BCEFB99.9080806@tmr.com> <4BCF163C.6040604@cfl.rr.com>
	 <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>
	 <4BCF4693.3020101@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCF4693.3020101@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 21, 2010 at 11:40 AM, Tim Small <tim@buttersideup.com> wrot=
e:
> Mark Knecht wrote:
>> This machine only gets a few hours of use a day but is generally
>> powered up all the time. I don't know why Linux wakes this drive up
>> roughly every two minutes, assuming it's Linux and not the drive
>> itself or something on the motherboard, but it does.
>>
>
>
> This is documented here:
>
> https://ata.wiki.kernel.org/index.php/Known_issues#Drives_which_perfo=
rm_frequent_head_unloads_under_Linux
>
> If you want to fix it, then wdidle3.exe worked for me. =C2=A0Search f=
or:
>
> wdidle3_1_00.zip
>
>
> Tim.
>

Yeah, that's been reported here before, but how does someone run this
Windows program on a remote machine that boots only Linux? Even if it
was a DOS executable the machine has no floppy. I presume you are
dual-boot with Windows? If so maybe I'll install Windows the next time
I visit.

I presume I cannot run this in a VM?

It's unfortunate that this drive doesn't respond to APM commands either=
=2E

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
