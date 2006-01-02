From: Czigola Gabor <czigola@elte.hu>
Subject: Re: big raid5 trouble
Date: Mon, 2 Jan 2006 15:46:51 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0601021532480.7066@Kamorka>
References: <Pine.LNX.4.63.0601012310180.10488@Kamorka> <43B8649A.5030102@panix.com>
 <Pine.LNX.4.63.0601020418570.15229@Kamorka> <43B91175.6040200@panix.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43B91175.6040200@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: berk walker <berk@panix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 2 Jan 2006, berk walker wrote:

> The "spare" disk would be just that, spare, like a spare tire for a car, 
> pressure is up, ready to go.  Each drive contained unique information, which 
> could be reconstructed from the remaining n-1 drives.  You now have 1 drive 
> "the spare" with no data, and an n-2  array.  You will probably lose data, 
> though the 3rd disk might have had errors in an unused area.  You can FORCE 
> the drives back into an array if things aren't too trashed.  I can not tell 
> what is the safest way to do this, but someone here may. 
> b-

Yes, but the spare disk is just logically spare, because it was in the 
array just before everything got wrong. I mean the data is untouched on 
it. If I force it (with editing the raw disk superblock) to get a normal 
active disk, should it behave like before the cutoff, shouldn't it? Or 
does the RAID mechanism erase/change anything else on the disk that makes 
this process impossible?

-- 
Czigola Gabor
