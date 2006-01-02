From: berk walker <berk@panix.com>
Subject: Re: big raid5 trouble
Date: Mon, 02 Jan 2006 06:41:41 -0500
Message-ID: <43B91175.6040200@panix.com>
References: <Pine.LNX.4.63.0601012310180.10488@Kamorka> <43B8649A.5030102@panix.com> <Pine.LNX.4.63.0601020418570.15229@Kamorka>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.63.0601020418570.15229@Kamorka>
Sender: linux-raid-owner@vger.kernel.org
To: Czigola Gabor <czigola@elte.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Czigola Gabor wrote:

> On Sun, 1 Jan 2006, berk walker wrote:
>
>> I don 't think that will help you, per se.  Why do you say it is your 
>> last chance? If you have n-1 disks OK, then you may be OK.  If not, a 
>> spare will not help.  Can you tell us more?
>> b-
>>
>
> So there is a RAID5 array with 4 disks. I had a long power failure, 
> and during the boot sequence, I saw that the 4th disk got marked as 
> non fresh. I started the process that should bring the 4th disk back 
> in the array, but during this the 3th disk died. The 4th disk is now 
> marked as spare.
>
> Meanwhile a found the 4k superblock on the disk (strace mdadm -E), and 
> I got - from the source of mdadm - the exact location of the spare 
> flag. But I guess, I have to recalc the correct checksum of the new 
> superblock.(?)
>
The "spare" disk would be just that, spare, like a spare tire for a car, 
pressure is up, ready to go.  Each drive contained unique information, 
which could be reconstructed from the remaining n-1 drives.  You now 
have 1 drive "the spare" with no data, and an n-2  array.  You will 
probably lose data, though the 3rd disk might have had errors in an 
unused area.  You can FORCE the drives back into an array if things 
aren't too trashed.  I can not tell what is the safest way to do this, 
but someone here may. 

b-

