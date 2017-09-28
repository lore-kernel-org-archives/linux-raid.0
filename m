From: Xuesong LU <disluxs@nus.edu.sg>
Subject: Re: Need Help for Raid Recovery
Date: Thu, 28 Sep 2017 13:31:04 +0800
Message-ID: <5d0b41c1-57e7-b2df-ea13-ca7242e036e1@nus.edu.sg>
References: <ccba6492-26b7-c084-aa1e-6d69c7f48785@nus.edu.sg>
 <59C94393.8010405@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59C94393.8010405@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I got the problem solved with some luck.

I am not sure how the problem came out. The thing was that the server
suffered from a sudden power-off and went into the emergency mode
(centos 7) after power resumed. In the emergency mode, I could not
assemble md0 and also could not see some of the physical volumes (which
actually had made me panic), and the system could not enter the default
mode after reboot.

Then after a few tries I simply ran 'mount -a' as suggested on the web.
It said /dev/sdd1 could not be found, though I could see sdd1 by running
'ls /dev'. So I commented out sdd1 in /etc/fstab, and had the system
enter the default mode after rebooting twice. Surprisingly and
differently from what I saw under emergency mode, all the filesystems
including md0 were just fine, even if I had deleted the line about md0
array in mdadm.conf file.

I am not quite sure about what actually happened, but what I learned is
that the filesystems one can see under emergency mode are different from
that under default mode (probably because of the minimum load). So don't
panic if one finds some pvs, lvs or even raids disappear for no reason
under emergency mode. Try to find which filesystem is actually missing
(e.g., run 'mount -a') and comment it out in the fstab file. Then try to
boot into the default mode, and most probably, all files are just as
good as what they were.

Thank Wol and Hank anyway for the reply:)

Best,
Xuesong

On 9/26/2017 1:57 AM, Wols Lists wrote:
> On 25/09/17 08:53, Xuesong LU wrote:
>> mdadm --examine /dev/sd[g-p] prints raid partition information for
>> sd[h,i,j,l,m,n]. No superblock detected on sd[g,k,o,p].
>>
>> mdadm --examine /dev/sd[g-p]1 prints raid partition information for
>> sd[h,i,j,l,m,n]1. The event counts are the same. It also prints 'No
>> superblock detected' for sdg1, and 'no such files' for sd[k,o,p]1.
>> (Gone? Can still recover?)
>>
>> I have UUID for md0 in the mdadm.conf file.
>>
>> Is there still hope to recover my raid? Thank you!
> Go to the raid wiki, and post the requested info to the list.
>
> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>
> Make sure you're using the latest mdadm.
>
> This looks a little familiar to me, but so long as nothing has written
> to the disk, and/or the only thing that has been damaged is the
> superblocks, this looks rather hopeful.
>
> Bear in mind, though, if the superblocks ARE gone, then it's going to be
> a hassle to get it back. A fair bit of trial and error is on the cards
> (read up on overlays). But as long as nothing has actually stomped on
> the data itself, you should be able to get it back.
>
> Do an "fdisk -l" on k, o, p. I remember a problem a while back when
> something stamped on the partition table ...
>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


________________________________

Important: This email is confidential and may be privileged. If you are not the intended recipient, please delete it and notify us immediately; you should not copy or use it for any purpose, nor disclose its contents to any other person. Thank you.
