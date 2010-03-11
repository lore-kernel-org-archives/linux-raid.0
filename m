From: Luca Berra <bluca@comedia.it>
Subject: Re: ANNOUNCE: mdadm 3.1.2 - A tool for managing Soft RAID under
	Linux
Date: Thu, 11 Mar 2010 13:29:47 +0100
Message-ID: <20100311122947.GA20914@maude.comedia.it>
References: <19351.10758.612499.310262@notabene.brown> <4B98D322.7010101@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B98D322.7010101@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 11, 2010 at 12:25:22PM +0100, Asdo wrote:
> Neil Brown wrote:
>> I am pleased to announce the availability of
>>    mdadm version 3.1.2
>>
>> [CUT]
>>
>> Significant changes are:
>>   - The default metadata has change again (sorry about that).
>>     It is now v1.2 and will hopefully stay that way. [CUT]
>>   
> I remember some discussion about alignment for 1.1 and 1.2: is it possible 
> on 1.2 to guarantee alignment of RAID device on the physical devices?
> 4K alignment would be needed on SSDs and 2TB disks w/ 4k physical 512b 
> logical emulation. Actually on SSDs the alignment could be even more than 
> 4k, I am not sure.
is there any problems with this commit?
http://neil.brown.name/git?p=mdadm;a=commit;h=a380e2751efea7dfe8acf0b95419c65ccacfa7cf

> Should we bypass the defaults and put 1.0 metadata on those?
> What was the downside of 1.0 so that it was not made default?
this has been discussed to boredom

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
