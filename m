From: Vlad Dobrotescu <vlad@dobrotescu.ca>
Subject: Re: RAID6 questions (mdadm 3.2.6/3.3.x)
Date: Fri, 11 Jul 2014 23:21:04 -0400
Message-ID: <53C0A9A0.2020508@dobrotescu.ca>
References: <53C06815.2020302@dobrotescu.ca> <B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com> <20140712112034.6b04d49f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140712112034.6b04d49f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/2014 21:20, NeilBrown wrote:
> On Fri, 11 Jul 2014 19:09:48 -0600 Chris Murphy<lists@colorremedies.com>
> wrote:
>>> 7. I am sure I read somewhere (can't find the source anymore) that the "new" RAID features of LVM2 are based on a fork from the md code. If this is true, are you guys are contributing to that project as well?
>> It's a good question, I'm not certain but my understanding is device mapper is leveraging existing md code in the kernel, rather than having forked and duplicated that code. They have their own user space tools and on-disk metadata so you can't use mdadm to manage it.
> Your understanding is correct.  It is the same code for managing RAID
> functionality, but different code for managing metadata and different
> user-space tools.
> I'm hoping that one day the RAID support in LVM2 will be better than mdadm,
> and then I can just fade away and no-one will notice that I am gone.
>
> http://downatthirdman.files.wordpress.com/2010/06/grinning-chesire-cat.jpg
>
> NeilBrown
Thanks for the insight. I don't think your "hope" will ever come to 
reality, as they seem to be focused on a different "business case". I 
find the LV abstraction pretty cool, but, for my needs, their RAID 
support needs significant improvements. It seems a bit weird to have 
access to all the amazing md code from the kernel and not being able to 
use it to its value. That's why the idea of a fork made more sense to 
me. But, then, I don't know if in fact the features that seem important 
for me (i.e. adding disks/stripes to an array) are in the kernel code or 
in the user-space tools. Maybe I should take a look at the md/mdadm code 
... until then, this question only comes from some kind of "academic" 
curiosity.

Would you have any opinion on the questions 1-5?

Vlad
