From: Arild Langseid <arild@langseid.no>
Subject: Re: need help: corrupt files on one of my raids
Date: Wed, 11 Nov 2009 09:15:52 +0100
Message-ID: <4AFA72B8.8010802@langseid.no>
References: <4AF97388.5080907@langseid.no>	 <70ed7c3e0911100734m31cd846t9987d6141d2513a6@mail.gmail.com>	 <4AF99159.4000800@langseid.no>	 <70ed7c3e0911101026k5e7ba489s6f3e492acc568d2f@mail.gmail.com>	 <4AF9CB19.7000803@langseid.no>	 <70ed7c3e0911101231r9e7e8b0nfcd94a60e5635831@mail.gmail.com>	 <4AF9D194.6000306@langseid.no>	 <70ed7c3e0911101829x48e6eb68o892ef11b2ff2d19@mail.gmail.com> <4877c76c0911102016k63f3e8ccled2b7f2a5cc3dffd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911102016k63f3e8ccled2b7f2a5cc3dffd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Michael:

I still ran your advice and got this result:

creator:~# mdadm  -D /dev/md1
/dev/md1:
         Version : 00.90

Is it a big problem running version 0.9? I use the version of the tools 
that comes with Debian - and as they are "some" conservative their 
versions lags some behind.

I have now upgraded my Debian Etch to Debian Lenny and have this mdadm:
creator:~# mdadm --version
mdadm - v2.6.7.2 - 14th November 2008

When I fix the firmware issues on my motherboard or buys a sepparate 
sata controller.... will the superblock be one of the version you 
suggests when I create the raid again? If not is it that large problem 
and I should upgrade my tools beyond what Debian provides?

Best Regards,
Arild




Michael Evans wrote:
> One other thing besides what's already been mentioned.  You are seeing
> issues with Raid1 and -not- your Raid5 volume.  If you run mdadm -D
> /dev/md(whatever the number is) what version (for the superblock) is
> reported?  Preferably you will be using either superblock 1.1 or 1.2
> (preferably 1.1).  The only reason to use mdadm 1.0 or 0.9 are special
> cases, such as for /boot style volumes.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

