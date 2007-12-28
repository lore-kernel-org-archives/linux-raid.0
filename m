From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: On the subject of RAID-6 corruption recovery
Date: Fri, 28 Dec 2007 09:34:58 -0800
Message-ID: <477533C2.6090808@zytor.com>
References: <4774663C.5090609@zytor.com> <47750A58.1010702@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47750A58.1010702@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bill Davidsen wrote:
> H. Peter Anvin wrote:
>> I got a private email a while ago from Thiemo Nagel claiming that some 
>> of the conclusions in my RAID-6 paper was incorrect.  This was 
>> combined with a "proof" which was plain wrong, and could easily be 
>> disproven using basic enthropy accounting (i.e. how much information 
>> is around to play with.)
>>
>> However, it did cause me to clarify the text portion a little bit.  In 
>> particular, *in practice* in may be possible to *probabilistically* 
>> detect multidisk corruption.  Probabilistic detection means that the 
>> detection is not guaranteed, but it can be taken advantage of 
>> opportunistically.
> 
> If this means that there can be no false positives for multidisk 
> corruption but may be false negatives, fine. If it means something else, 
> please restate one more time.
> 

Pretty much.  False negatives are quite serious, since they will imply a 
course of action which will introduce further corruption.

	-hpa

