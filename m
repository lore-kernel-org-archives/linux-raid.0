From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: big raid5 trouble
Date: Wed, 04 Jan 2006 02:16:24 -0500
Message-ID: <200601040216.24692.mlaks@verizon.net>
References: <Pine.LNX.4.63.0601012310180.10488@Kamorka>
 <43B91175.6040200@panix.com> <Pine.LNX.4.63.0601021532480.7066@Kamorka>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <Pine.LNX.4.63.0601021532480.7066@Kamorka>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 02 January 2006 09:46 am, Czigola Gabor wrote:

>
> Yes, but the spare disk is just logically spare, because it was in the
> array just before everything got wrong. I mean the data is untouched on
> it. If I force it (with editing the raw disk superblock) to get a normal
> active disk, should it behave like before the cutoff, shouldn't it? Or
> does the RAID mechanism erase/change anything else on the disk that makes
> this process impossible?

I am very interested in your recovery process having gone through it myself a 
number of times with hardware raid. 

I would also like to see how one can "set the flag" to accept the "spare" 
drive - into the array.

I hope the gurus here can tell us how to do it.

One thing you can do. Before you play with the data on your array, you can 
back up the individual hard drives to truely spare drives. Here you can use 
dd, or
dd with ignore error flags - see man page and google and dd_rescue man page or 
dd_rescue or 
dd_rescue with dd_rescue_help.

These amazing tools may even help with the "dead" drive. You can see what you 
can rescue. I was able to save some substantial data using those tools in the 
past. Beware that it may take a long time to  back up a severly damaged disk 
- thats why the tools were invented. 

Then you can try different techniques with your status "frozen".

It is this kind of headache that switched me to raid1 ...

Good Luck
Mitchell Laks
