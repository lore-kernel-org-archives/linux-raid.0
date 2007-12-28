From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: On the subject of RAID-6 corruption recovery
Date: Fri, 28 Dec 2007 09:38:16 -0500
Message-ID: <47750A58.1010702@tmr.com>
References: <4774663C.5090609@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4774663C.5090609@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> I got a private email a while ago from Thiemo Nagel claiming that some 
> of the conclusions in my RAID-6 paper was incorrect.  This was 
> combined with a "proof" which was plain wrong, and could easily be 
> disproven using basic enthropy accounting (i.e. how much information 
> is around to play with.)
>
> However, it did cause me to clarify the text portion a little bit.  In 
> particular, *in practice* in may be possible to *probabilistically* 
> detect multidisk corruption.  Probabilistic detection means that the 
> detection is not guaranteed, but it can be taken advantage of 
> opportunistically.

If this means that there can be no false positives for multidisk 
corruption but may be false negatives, fine. If it means something else, 
please restate one more time.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


