From: berk walker <berk@panix.com>
Subject: Re: big raid5 trouble
Date: Sun, 01 Jan 2006 18:24:10 -0500
Message-ID: <43B8649A.5030102@panix.com>
References: <Pine.LNX.4.63.0601012310180.10488@Kamorka>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.63.0601012310180.10488@Kamorka>
Sender: linux-raid-owner@vger.kernel.org
To: Czigola Gabor <czigola@elte.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Czigola Gabor wrote:

> Hello all!
>
> I'm not sure, that is this the right place to ask such question, but 
> I'm in a big trouble with my RAID5 array.
>
> My last chance to get any of the data back stored in this array, is to
> "unspare" a spare disk, that is untouched since the removal.
>
> I googled but can't find neither a documentation nor a specification 
> where and how the spare flag is stored on a disk. Can you please help me?
>
> Thanks a lot.

I don 't think that will help you, per se.  Why do you say it is your 
last chance? If you have n-1 disks OK, then you may be OK.  If not, a 
spare will not help.  Can you tell us more?
b-

