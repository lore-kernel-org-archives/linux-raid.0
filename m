From: Arild Langseid <arild@langseid.no>
Subject: Re: need help: corrupt files on one of my raids
Date: Wed, 11 Nov 2009 09:06:45 +0100
Message-ID: <4AFA7095.2030207@langseid.no>
References: <4AF97388.5080907@langseid.no>	 <70ed7c3e0911100734m31cd846t9987d6141d2513a6@mail.gmail.com>	 <4AF99159.4000800@langseid.no>	 <70ed7c3e0911101026k5e7ba489s6f3e492acc568d2f@mail.gmail.com>	 <4AF9CB19.7000803@langseid.no>	 <70ed7c3e0911101231r9e7e8b0nfcd94a60e5635831@mail.gmail.com>	 <4AF9D194.6000306@langseid.no>	 <70ed7c3e0911101829x48e6eb68o892ef11b2ff2d19@mail.gmail.com> <4877c76c0911102016k63f3e8ccled2b7f2a5cc3dffd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911102016k63f3e8ccled2b7f2a5cc3dffd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
Cc: Michael Evans <mjevans1983@gmail.com>, "Majed B." <majedb@gmail.com>
List-Id: linux-raid.ids

Hi Michael and Majed!

Thank you very much for your help!

One good fellow in Australia reqognized my motherboard as the source of 
my problems. And sent me this privately as he does not has 
write-permissions to the list:

As Tony writes - my problems started when I connected the seccond drive 
and started raiding it. The raid5 volumes is on two separate promise-ide 
controllers so that's the reason I have no problems with that.



Tony wrote:
 > Hi Arild -
 >
 > Greetings from Australia...
 >
 > As I only have read access to the Raid List - I hope you do not mind my
 > replying to you directly.
 >
 > I understand that you are using a Abit NF7 motherboard with two Onboard
 > Silicon Image 3112 SATA ports (which makes it a NF7-S)  to which are
 > connected two  SATA drives - and you are having data corruption problems
 > with these particular drives.
 >
 > This is a known problem with this motherboard. If you connect only one
 > drive - no problem. However, connect two - and you have problems!
 >
 > I actually have one of these motherboards and to solve the problem I
 > disabled the Onboard SATA and installed a SATA controller in one of the
 > PCI slots. It was the quickest and easiest solution. I needed more than
 > two SATA ports anyway - so wasn't a problem. Just installed a 4 port 
card.
 >
 > If you search on the Internet there are a number of discussions on this
 > - examples - just a very quick search.
 > You may find a good fix - I took the easy way out!
 >
 > 
http://www.techspot.com/vb/all/windows/t-5278-SATA-RAID-data-corruption-problem-update.html 

 >
 > http://www.nforcershq.com/forum/image-vp65255.html
 > http://www.tomshardware.com/forum/103163-30-bios-update-problem
 >
 > Good Luck,  Tony
 >


Thanks you very much for all the help.

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

