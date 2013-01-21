From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Recovering RAID1 superblock
Date: Mon, 21 Jan 2013 21:09:20 +0000
Message-ID: <50FDAE80.5090907@anonymous.org.uk>
References: <50FDA7E4.9010705@univation.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50FDA7E4.9010705@univation.de>
Sender: linux-raid-owner@vger.kernel.org
To: Eddy Ilg|univation <eddy.ilg@univation.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/01/2013 20:41, Eddy Ilg|univation wrote:
> Dear linux-raid users,
>
> I have a disk of a 2-disk RAID1 array with damaged superblock. Please
> forgive me if this question as already been asked, but as I am afraid of
> executing a dangerous command, I need to ask:
>
> To recover the superblock, I would run
> mdadm --create /dev/md2 --level=1 --raid-devices=2 /dev/sdb2 missing
>
> Is is correct, that this will NOT erase the data on /dev/sdb2?

As long as you're using the same mdadm version as the array was created 
with, and that is the create command used in the first place (apart from 
the "missing" bit of course), then yes.

If it's a different mdadm version, it may have a different default 
metadata type, so the new metadata might overwrite the original data area.

Different mdadm versions create arrays with different data offsets too, 
so even if the new create doesn't overwrite your old metadata, you may 
not be able to see your data (or at least, your filesystem may not be 
able to make sense of it).

So be sure to save a copy of `mdadm --examine /dev/sdb2` before you 
start, then check the man pages and release notes for the mdadm 
version(s) you're using.

Cheers,

John.

