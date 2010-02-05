From: Bill Davidsen <davidsen-sQDSfeB7uhw@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 	support handoff after pivotroot
Date: Thu, 04 Feb 2010 19:21:59 -0500
Message-ID: <4B6B64A7.4010003@tmr.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	 <1263242294-5353-3-git-send-email-dledford@redhat.com>	 <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>	 <20100204174009.6072ec07@notabene.brown> <4B6B15B3.8030205@redhat.com> <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin f krafft <madduck-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

Dan Williams wrote:
> On Thu, Feb 4, 2010 at 11:45 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>   
>> To be fair, if post-hoc versus initial made any difference what so ever,
>> then so would the fact that I wouldn't have chosen to have these files
>> exist at all.  I would have made incremental assembly work without a map
>> file and I would have made imsm superblock handling be in the kernel.
>> So, I'm dealing with the consequences of decisions I didn't make and
>> wouldn't have made.  I don't think it's then fair to put some sort of
>> 'premeditated' versus 'dealing with the situation' bias on my response.
>>     
>
> On the argument about where to place the mdmon files I am now torn
> between the "Neil" and "Doug" positions, but on the decision of where
> to place imsm superblock handling I stand behind the design decision
> to put it in userspace.
>
> 1/ If you take a look at native md superblock support you see that the
> support code is duplicated between kernel-space and user space, having
> it all handled in userspace means only one code base to maintain
> (elegant aspect #1).
>   

That is the decision which I question. Having anything mission critical 
in user space means that there suddenly arise ownership, privilege and 
scheduling issues which just don't exist for things in the kernel.

Just my opinion, I believe it introduces additional points of failure. 
Perhaps like crypto it could be called from user or kernel space but 
live in the kernel.

-- 
Bill Davidsen <davidsen-sQDSfeB7uhw@public.gmane.org>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein
