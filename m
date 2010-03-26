From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: 4 partition raid 5 with 2 disks active and 2 spare, how to force?
Date: Fri, 26 Mar 2010 19:29:56 +0000
Message-ID: <4BAD0B34.9060102@anonymous.org.uk>
References: <S1753093Ab0CYHZE/20100325072504Z+37@vger.kernel.org> <2E4545D6-8F4E-4779-9103-960C52983A72@brillgene.com> <4877c76c1003250437r346e18en8da0f6f804bef634@mail.gmail.com> <DFC0232A-8DCD-4815-AA08-DA7065F01221@brillgene.com> <4877c76c1003252038o655b2a29p9d994df27b5d2afd@mail.gmail.com> <6093BE49-EE3B-41B5-9519-C6D5D0496C64@brillgene.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6093BE49-EE3B-41B5-9519-C6D5D0496C64@brillgene.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman@brillgene.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/03/2010 16:28, Anshuman Aggarwal wrote:
[...]
> mdadm --assemble  /dev/md_d127 /dev/sda1 /dev/sdb5 /dev/sdc5 /dev/sdd5
> mdadm: /dev/md_d127 assembled from 2 drives and 1 spare - not enough to start the array.
[...]

You said sda was broken, so forget that. Goodness knows how sdd5 managed 
to end up being a spare. I think you want `mdadm --assemble /dev/md_d127 
--force /dev/sd[bcd]5`. I don't think you can start it read-only but 
with a member missing you're not going to get a resync going so this is 
unlikely to cause data loss. Still, don't do this if you don't believe 
it's the correct answer, and certainly don't blame me if it wastes your 
data. Good luck!

Cheers,

John.
