From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Possible failures in raid5?
Date: Tue, 28 Dec 2004 22:35:33 -0500
Message-ID: <200412290335.iBT3Zc913406@www.watkins-home.com>
References: <41D1EB01.1040204@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41D1EB01.1040204@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'John McMonagle' <johnm@advocap.org>, "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For testing the disk(s) status, look at smartd.
My disks are too old, but newer disks should support this.

I run a Seagate tool every night.  I believe my disks relocate bad blocks on
read, but only if they can be read with error correction.

Before I started using the Seagate tool, I used dd.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of John McMonagle
Sent: Tuesday, December 28, 2004 6:24 PM
To: Peter T. Breuer
Cc: linux-raid@vger.kernel.org
Subject: Re: Possible failures in raid5?

Thanks Peter

If one is using a journaling file system like ext3. Will that fix the 
problem area?
My concern was that writes are being done in larger chunks than the 
written data but possibly that is not a problem.

Another issue is it's good to know about any disk failures as soon as 
possible.

I see someone has suggested running something like
dd if=/dev/sda of=/dev/null bs=64k

I have used that before and it does work. What I would prefer is to run 
it periodically and email on failures.
I haven't seen any scripts for this.
Not that hard to do but I'm wondering how to detect errors in the script.
When I ran by hand in the past I got scsi errors even if the read 
ultimately worked.
Kind of hard to test without a bad drive on hand :)
If one redirects errors to a file will the scsi or ide errors go to the 
file?

John

Peter T. Breuer wrote:

>John McMonagle <johnm@advocap.org> wrote:
>  
>
>>I am  concerned what will happen if the computer dies while writing a
strip.
>>    
>>
>
>Well, the strip will be partially written.
>
>  
>
>>Is it possible that the stripe will be corrupted?
>>    
>>
>
>No - it will be partially written.  The parity data may or may not be
>consistent with the real data at that point, and if you lose a disk
>before the next resync (at next reboot) you may get some different data
>reconstructed using parity than if you had used the data itself. OTOH
>if you reboot with all disks intact the parity will be reconstructed
>properly and the inconsistency will be removed. But any missed writes
>will remain missing.
>
>  
>
>>If so will the  the rest of the raid array be OK?
>>    
>>
>
>Apart from that strip?  I'm not sure exactly what you mean by "strip"
>(probably some raid jargon?  Don't they use "chunks" and "stripes"?)!
>But clearly the data inconsistency will be confined to it.
>
>  
>
>>if so is there anything one can do  about it?
>>    
>>
>
>? Nothing has happened - you have simply not written all the
>data you wanted to write. This happens all the time when writing to
>disks and crashing your computer! But since raid writes at least twice,
>once for data and once for parity, you have the extra pssibility of 
>having missed some of the parity data (or having written parity but not
>data). That produces an inconsistency in the redundant data. You can
>fix it by rebooting with all disks intact. Hey - you even fix the
>inconsistency by rebooting with one missing; you just have less chance
>of reconstructing the intended data that way.
>
>Peter
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

