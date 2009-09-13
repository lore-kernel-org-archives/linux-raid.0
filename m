From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID mirror, resyncing from bad disk
Date: Mon, 14 Sep 2009 01:49:35 +0300
Message-ID: <70ed7c3e0909131549y196c06c9m7d91f73bf5adeac2@mail.gmail.com>
References: <4AAD45AE.6060503@amazinginternet.com> <4AAD5510.2060505@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AAD5510.2060505@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Ronny Adsetts <ronny.adsetts@amazinginternet.com>, Linux RAID ML <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If your data is backed up, doing everything from scratch is your best
bet, and I'll tell you why you shouldn't try to patch up your current
situation:

1) Have you written a single byte to the array(s) when the first disk
was thrown out of the array?
If yes, then adding it again will be equal to adding a new hard disk.
If no, then why was it trying to resync? I think it's already flagged
dirty but you've got 99.2% worth of data...

2) Your disk that is currently running the RAID1 array has bad sectors.
If you try to clone that, you'll fail to clone all sectors, which
means loss of data.

3) Ignoring bad sectors means you'll end up with corrupt Physical
Volumes under the LVM (Since your arrays are Physical Volumes of the
LVM). This will also cause problems with the filesystem.

I would suggest buying TWO new disks and reinstall everything and
restore your backup(s) then data. It's better than spending numerous
hours trying to find out why a service isn't working, then after days
you realize that some binaries are corrupt or the config files.

The reason I say TWO new disks, is that you already have one disk with
bad sectors, and the other popped out of the array for a reason. Do
not add the 2nd disk until you're truly sure there's nothing wrong
with it (run smartd and execute short and long tests, try to read the
whole disk a few times using dd: dd if=/dev/sdc of=/de/null bs=10M).

If you see link errors in the kernel/dmesg, change your SATA cables.

>> The problematic array is /dev/md2 and the dying disk is /dev/sdc.
>>
>> When I try to resync it gets to about 99.2% then gives load of I/O errors
>> in /var/log/kern.log and finally gives up and restarts the sync.
>>
>> Ideally I just want to tell the system to ignore the bad sector and just
>> resync the array.
>>
>> Does anyone have any ideas on how I can get this resolved short of
>> reinstalling?
-- 
       Majed B.
