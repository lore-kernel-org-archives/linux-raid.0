From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [mdadm PATCH 1/1] Fix a building error
Date: Tue, 19 Sep 2017 14:33:24 +0100
Message-ID: <59C11CA4.7060907@youngman.org.uk>
References: <1505816081-7887-1-git-send-email-xni@redhat.com>
 <059748ff-f5b9-bdf5-a4eb-ff1acbaa60c3@molgen.mpg.de>
 <815339809.11997756.1505827012878.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <815339809.11997756.1505827012878.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: jsorensen@fb.com, zlliu@suse.com, linux-raid@vger.kernel.org, Nigel Croxon <ncroxon@redhat.com>
List-Id: linux-raid.ids

On 19/09/17 14:16, Xiao Ni wrote:
> 
> 
> ----- Original Message -----
>> From: "Paul Menzel" <pmenzel@molgen.mpg.de>
>> To: "Xiao Ni" <xni@redhat.com>
>> Cc: jsorensen@fb.com, zlliu@suse.com, linux-raid@vger.kernel.org
>> Sent: Tuesday, September 19, 2017 6:24:52 PM
>> Subject: Re: [mdadm PATCH 1/1] Fix a building error
>>
>> Dear Xiao,
>>
>>
>> Please find some comments and nits below.
> 
> Hi Paul
> 
> Thanks for these suggestions. 
> 
>>
>> On 09/19/17 12:14, Xiao Ni wrote:
>>> In s390 platform, it gives a building error:
>>
>> s/building error/build error/
>>
>> Maybe: On s390 platform the build fails with the error below.
> 
> Ok. 

c/On s390/On the s390/
>>
>>> Manage.c: In function 'Manage_subdevs':
>>> Manage.c:1502:5: error: passing argument 3 of 'fstat_is_blkdev' from
>>> incompatible pointer type [-Werror]
>>>       fstat_is_blkdev(tfd, dv->devname, &rdev);
>>>       ^
>>> In file included from Manage.c:25:0:
>>> mdadm.h:1446:12: note: expected 'dev_t *' but argument is of type 'long
>>> unsigned int *'
>>>
>>> It was introduced by 0a6bff09 and add a temp variable to fix this.
>>
>> Maybe: It is introduced by commit 0a6bff09 (mdadm/util: unify fstat
>> checking blkdev into function). So use a temp variable to fix this.
> 
> Yes, the word so is better. Sorry for my pool English.

It's not bad ... :-)

revert with

c/is/was/

Personally I probably wouldn't abbreviate "temporary", but that's a
matter of taste.
>>
>>>
>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> ---
Cheers,
Wol

