From: Jean Jordaan <jean@upfrontsystems.co.za>
Subject: Re: Recovering RAID5 array
Date: Tue, 20 Jan 2004 12:44:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400D0679.2040603@upfrontsystems.co.za>
References: <400CD0BF.2010808@upfrontsystems.co.za>	<16396.53737.911347.812076@notabene.cse.unsw.edu.au>	<400CE215.2050502@upfrontsystems.co.za> <16396.64514.820157.677722@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16396.64514.820157.677722@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>cdimage root # mdadm --verbose --assemble /dev/md0 --force /dev/hda3 /dev/hdb3 
>>/dev/hdc3
>>mdadm: looking for devices for /dev/md0
>>mdadm: /dev/hda3 is identified as a member of /dev/md0, slot 3.
>>mdadm: /dev/hdb3 is identified as a member of /dev/md0, slot 4.
>>mdadm: /dev/hdc3 is identified as a member of /dev/md0, slot 2.
>>mdadm: no uptodate device for slot 0 of /dev/md0
>>mdadm: no uptodate device for slot 1 of /dev/md0
> 
> Looks like you must have done a hot-add in the mean time....

What I did: first --set-faulty /dev/hda3. After that I tried to
add it back, but got an error reporting that the array isn't
running because there aren't enough components of it available,
and that the device could therefor not be added.

-- 
Jean Jordaan
http://www.upfrontsystems.co.za

