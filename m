From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Installing Linux directly onto RAID6 Array...........
Date: Wed, 13 May 2015 10:02:40 +1000
Message-ID: <555294A0.6040703@websitemanagers.com.au>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/05/15 20:08, Another Sillyname wrote:
> I've tried to do some research on this but the information out there
> seems a bit contradictory (mainly because some is so old).
>
> I want to install Fedora directly onto a RAID array (no separate boot disk).
>
> My plan is to 'pre configure' the 6 drives as a clean RAID6 array,
> effectively sd[a-f] without partitions and then attempt to install
> Fedora 21, from sources it looks like Grub2 should recognise the array
> and then allow the Kernel to boot thereby 'enabling' the array to
> become visible and active.
>
> However I have not been able to find an actual example of someone
> trying this......thoughts?
>
> The reason to do this is I'm intending to use a Mini ITX board with 6
> sata ports and want to use 8TB drives in Raid6 to give me a very high
> density data resilient small form factor storage box.
>
> Ideas/Suggestions?

Create a small RAID1 partition at the beginning of every disk, use this 
for /boot and install grub. Use the rest of each disk as your RAID6 array.

This means as long as the bios can find any one of your disks, then the 
system will boot. Personally, I'd be inclined to put the complete OS on 
the RAID1, and then only use the RAID6 for the "data" mountpoint. This 
would allow the system to come up fully, even without the RAID6 (eg, 4 
out of 6 drives has died), and allow remote debug/diagnostics/etc 
without needing to try and boot from a rescue disk/etc.

This doesn't help you with what you asked, but just an idea/suggestion.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
