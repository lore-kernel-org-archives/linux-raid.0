From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Best way to re-format RAID1 disks
Date: Thu, 26 Mar 2009 09:05:03 -0400
Message-ID: <87f94c370903260605l2744ba6di9723c53125d9a1a8@mail.gmail.com>
References: <26c008d70903260410y22c8af1ocf00138a1ff6a2b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26c008d70903260410y22c8af1ocf00138a1ff6a2b6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Federico <undicizeri@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You forgot the most important step.

Step 0: ensure you have a valid backup of your data.

On 3/26/09, Federico <undicizeri@gmail.com> wrote:
> Hi all,
> I've two disks in RAID1 formatted with reiserfs which, in my system,
> has  amazingly poor performance... I want to switch to ext3 and in a
> couple of kernel releases to upgrade to ext4.
> This is my plan:
>
> 1 - Remove one disk from the array
> 2 - Format the removed disk with ext3 filesystem
> 3 - Copy all the data from the degradeted RAID to the newly ext3-formatted
> disk
> 4 - Create a new degradeted RAID1 with the ext3 disk
> 5 - Modify grub and reconfigure mdadm to boot in the ext3 RAID1 disk.
> 6 - Reboot.
> 7 - Reformat the reiserfs disk
> 8 - Add the formatted disk to the ext3 RAID and start to syncing.
>
> Is there a more easy and failproof method?
> I'm a bit scared to lose same (or all) of my data during the process...
> Thank you for your help :P
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Sent from my mobile device

Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
