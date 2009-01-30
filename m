From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Fri, 30 Jan 2009 10:28:59 -0500
Message-ID: <49831CBB.8010609@tmr.com>
References: <1233174633.7008.34.camel@hazard2.francoudi.com> <20090128223330.GA14409@sillage.bis.pasteur.fr> <20090128230852.GA8495@francoudi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090128230852.GA8495@francoudi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vladimir Ivashchenko <hazard@francoudi.com>
Cc: Tru Huynh <tru@pasteur.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Vladimir Ivashchenko wrote:
> On Wed, Jan 28, 2009 at 11:33:30PM +0100, Tru Huynh wrote:
>
>   
>>> CentOS 5.2, 2.6.18-92.1.22.el5PAE, sata_mv. Two dual-core Opterons @ 2.8
>>> Ghz, 16 GB RAM.
>>>       
>> any reason for using the 32 bits version instead of the 64 bits?
>>
>> you must also be aware of http://kbase.redhat.com/faq/docs/DOC-15593
>>
>> just my .2 cents
>>     
>
> Always welcome :)
>
> According to http://epubs.cclrc.ac.uk/bitstream/2943/ThumperReport.pdf, x4500 was shown to be unstable under centos/rhel 4.x (he didn't 
> use mv_sata though). In any case, centos 4.x is way too old.
>
> I changed the kernel to 2.6.27.12-78.2.8.fc9.i686 and so far it is stable. 
>
> x64 will be the next step. i686 is what our guys install by default, I didn't bother to reinstall it.
>
>   
In spite of the theoretical benefits of 64 bit, I find that the 
advantages are "measurable but not noticeable" for most things. The lack 
of 64 bit versions of some applications was a problem for me, but may 
not be for you. I did find that even building from source not all 
applications worked right, or worked at all, or in some cases compiled. :-(


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


