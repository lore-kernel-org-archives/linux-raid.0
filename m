From: berk walker <berk@panix.com>
Subject: Re: RAID 1 on a server with possible mad mobo
Date: Tue, 08 Mar 2005 20:08:44 -0500
Message-ID: <422E4C9C.8010307@panix.com>
References: <bbfa52890503081019478cb6cf@mail.gmail.com>	 <422DF363.6090105@steeleye.com> <bbfa528905030816484108fa7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <bbfa528905030816484108fa7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Colin McDonald <ce.mcdonald@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Grub is referenced to your boot drive, then from that it makes all 
references in relation to /.  The dox on that slightly sux, but it is 
really easy to see, if you can change to boot drive in bios. Run it 
crossways, whatever.  The bios disk boots, and will become home of /.  
Well, at least it has for me for 5 yrs.  Now your milage may vary, 
depending upon which disk your are booting, and the various flavours you 
have available on all of your bootable disks.  Xandros is really willing 
to try anything - suse barely likes itself.  The bottom line is to ask 
it.  Set up a configuration and try it.  It is a *good thing* to be 
backed up, tho.... I have seen OSs that automounted file systems rw, and 
then proceeded to trash them, presumably from ignorance.  One thing 
might be - if grub wants hd 0,0 is to have nothing there, I never do.
just a thought.
b-

Colin McDonald wrote:

>Thanks for the suggestions.
>
>Let me ask an additional question.
>
>Is it a bad idea to write the grub to a software mirror. Is it written
>to a specific disk when this is done?
>
>If I had a corrupt boot loader or boot sector and i needed to rescue.
>Would I point to the md device or one of the disks (or both).
>
>TIA
>
>
>On Tue, 08 Mar 2005 13:48:03 -0500, Paul Clements
><paul.clements@steeleye.com> wrote:
>  
>
>>Colin McDonald wrote:
>>
>>    
>>
>>>Without taking up to much of y'alls time, what would be the best
>>>solution for moving the RAID array over to a new box?
>>>      
>>>
>>>2. Try to boot off of the disks after they have been transferred into
>>>the new machine? I know this will cause all kinds of problems with
>>>kernel/devices, etc and probably won't work.
>>>      
>>>
>>Actually, I've done this a couple of times with both Red Hat and SUSE
>>and it's worked surprisingly well. With the kernel being mostly modular
>>and the hardware detection/configuration utilities being pretty advanced
>>these days, it's not much of a problem. (I had a minor issue with SUSE
>>doing this sort of thing because the MAC address of the NIC was
>>different, so the network stuff was not getting configured. On Red Hat
>>[and hopefully Fedora is still the same] you should get prompted at
>>bootup if there is any hardware to add or remove.)
>>
>>Especially if you're wanting to keep the system configuration exactly
>>the same, this may be the way to go, rather than trying to reconfigure
>>everything exactly the way you had it before.
>>
>>And of course if, after booting the new system with the old disks, you
>>find that things are not quite right, you can always re-install at that
>>point...
>>
>>--
>>Paul
>>
>>    
>>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>.
>
>  
>

