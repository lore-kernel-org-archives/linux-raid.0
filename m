From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Linux MD RAID5/6 bitmap patches
Date: Thu, 23 Mar 2006 10:07:09 -0500
Message-ID: <4422B99D.2030207@steeleye.com>
References: <WM55FF1C4E77EA475bABFCC81C4DDCE4A9@spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <WM55FF1C4E77EA475bABFCC81C4DDCE4A9@spsoftindia.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yogesh Pahilwan <pahilwan.yogesh@spsoftindia.com>
Cc: 'Neil Brown' <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yogesh Pahilwan wrote:

> Where can we get documentation (design/implementation) about RAID6 and
> bitmap for linux kernel 2.6.

For the bitmap code, I'm afraid you'll just have to read the code. Also, 
look back at the archives of this list. There are several discussions 
about the bitmap patches, going back to 2003.

--
Paul


> -----Original Message-----
> From: Paul Clements [mailto:paul.clements@steeleye.com] 
> Sent: Wednesday, March 22, 2006 11:37 PM
> To: Yogesh Pahilwan
> Cc: 'Neil Brown'; linux-raid@vger.kernel.org
> Subject: Re: Linux MD RAID5/6 bitmap patches
> 
> Yogesh Pahilwan wrote:
> 
> 
>>Thanks for your reply. As far as what I understood that when we apply the
>>bitmap patch, for every write it will do 2 sync writes that is setting the
>>dirty bit, writing intent log and one async write for clearing the dirty
>>bit. Is it correct?
> 
> 
> The bits are in the intent log, so the "setting dirty bit" and "writing 
> intent log" are the same thing. Just one write.
> 
> 
>>If that is the case are there any patches available which can do
> 
> collection
> 
>>of sync write in a queue and write a collection in single write request.
>>For Eg:
>>For 10 writes , we will have 10 + 1 sync writes + 10 async write.
> 
> 
> The bitmap code already does this by default. The bitmap writes are 
> queued up so that all writes to a given page (within a short time 
> period) are reduced to a single write. The performance is actually quite 
> good. There's very little performance difference between having a bitmap 
> versus not having one.
> 
> 
>>I mean to say , 10 sync writes for setting the dirty bits + 1 sync write
> 
> for
> 
>>write intent log for all queued request in one write operation + 10 async
>>write for clearing the dirty bit.
> 
> 
> The async writes for clearing the bitmap are also combined.
> 
> --
> Paul
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

