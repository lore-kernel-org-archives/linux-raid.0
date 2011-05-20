From: Paul van der Vlis <paul@vandervlis.nl>
Subject: Re: Software raid, booting and bios
Date: Fri, 20 May 2011 09:14:45 +0200
Message-ID: <ir54d5$g2n$1@dough.gmane.org>
References: <ir536c$9jv$1@dough.gmane.org> <6123979024523080515@unknownmsgid>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6123979024523080515@unknownmsgid>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Op 20-05-11 09:03, Simon Mcnair schreef:
> Please can you further define what you mean by 'it can become a
> problem to boot' ?
> Generally this is resolved by having a mbr and boot partition on each
> of your mirrored drives so that whichever you use to boot has the
> pertinent information to boot the kernel and construct the raid array.
> If you have raid 5 with 3 disks you'd have a 3 drive mirror partition
> on each disk and a raid 5 set across all three too.

In the bios from my machines (Supermicro, Dell) I can select only one
drive to boot. Wenn the drive fails, no other disk is tried.

I can go into the bios and change the drive when it fails, or I can
exchange the disks. But I would like it, when the machine would simple
boot even when the first disk is corrupt.

With regards,
Paul van der Vlis.


> I'm not a guru on this and can't provide much knowledge past the
> theory and high level ;-)
> Simon
> 
> On 20 May 2011, at 07:55, Paul van der Vlis <paul@vandervlis.nl> wrote:
> 
>> Hello,
>>
>> I use software raid (mdadm). The main problem for me is that when the
>> drive with the MBR fails, it can become a problem to boot.
>>
>> When the bios would use another drive to boot when the first drive
>> failes, this problem would be gone. But I don't know rackservers who do
>> that. Do you?
>>
>> Or is there maybe some kind of fake-raid card what uses mdadm to solve
>> this problem?
>>
>> Another way would be to use e.g. an USB device to boot to solve this
>> problem. Any experiences with that?
>>
>> (hmm, I realize that netboot is an option too).
>>
>> With regards,
>> Paul van der Vlis.
>>
>>
>> --
>> http://www.vandervlis.nl
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


