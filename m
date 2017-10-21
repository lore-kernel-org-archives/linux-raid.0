From: Anthony Youngman <antmbox@youngman.org.uk>
Subject: Re: WD nas broke can't accessmy files on RAID 1
Date: Sat, 21 Oct 2017 12:25:03 +0100
Message-ID: <bfbf59c2-c750-f87b-5167-37c84086bb75@youngman.org.uk>
References: <CAKNaYNuY8gNn+u4uMK8U+AnnYMmH8GNPDJGWTG1SNrQpDG4kjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKNaYNuY8gNn+u4uMK8U+AnnYMmH8GNPDJGWTG1SNrQpDG4kjA@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Francesco Tomadin <inamaru94@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/10/17 11:46, Francesco Tomadin wrote:
> As title says, due to a bug in the WD nas, it started creating
> infinite shares folder.
> At the moment I can't access my NAS anymore, so I decided to try
> ubuntu to recover my data.
> I tried to follow some guides and to check stuff but seems like
> (especially for my NAS) stuff like this doesn't exist.
> I don't even wanna try to do stuff on my own since as you can clearly
> see I'm not a linux user I don't even understand what's going on.
> 
> PS: My nas had 4 slot, one of them was in JBOD format, and with ubuntu
> I could easily access the data without problem.
> 
> Tried to use some mdadm command but It gave me some "strange" errors
> which I would ever try to "fix" on my own.
> Tried to give a last chance to my nas yesterday but it's stuck at boot.
> Please if someone could really help me task to task because I really
> really don't know what to do anymore.

Have you read the raid wiki? Is there any chance you could run the 
--detail and --examine commands? (Yes I get you may have problem finding 
the disks to be able to run the commands on them! :-)

https://raid.wiki.kernel.org/index.php/Linux_Raid

You might have to take the disks out of the NAS, or force the whole 
thing into JBOD mode, but again if it won't boot, that might not be 
possible ...
> 
> Sorry for my poor english It's not my first language.

Better than my foreign languages! If you can't express yourself clearly 
in English, then post bi-lingual. I'm guessing your first language is 
Spanish or Italian, which I don't understand, but there are probably 
people who do. But you need to use as much English as possible to get 
the best help.

Cheers,
Wol
