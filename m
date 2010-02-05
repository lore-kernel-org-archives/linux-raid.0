From: Luca Berra <bluca@comedia.it>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
	support handoff after pivotroot
Date: Fri, 5 Feb 2010 13:14:58 +0100
Message-ID: <20100205121458.GA23870@maude.comedia.it>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com> <1263242294-5353-3-git-send-email-dledford@redhat.com> <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com> <20100204174009.6072ec07@notabene.brown> <4B6B15B3.8030205@redhat.com> <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com> <4B6B64A7.4010003@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B6B64A7.4010003@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 04, 2010 at 07:21:59PM -0500, Bill Davidsen wrote:
>> 1/ If you take a look at native md superblock support you see that the
>> support code is duplicated between kernel-space and user space, having
>> it all handled in userspace means only one code base to maintain
>> (elegant aspect #1).
>>   
>
> That is the decision which I question. Having anything mission critical in 
> user space means that there suddenly arise ownership, privilege and 
> scheduling issues which just don't exist for things in the kernel.

lol @ /sbin/mount

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
