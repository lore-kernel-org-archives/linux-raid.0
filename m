From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Mon, 01 Feb 2010 15:32:29 -0500
Message-ID: <4B673A5D.2010901@tmr.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	<1263242294-5353-3-git-send-email-dledford@redhat.com> <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B55F138.7060008@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> On 01/18/2010 05:09 PM, Neil Brown wrote:
>   
>
>> I understand there is a problem here, but I don't like this approach to a
>> solution.  I'll give it more though when I get home from LCA2010 and see
>> what I can come up with.
>>     
>
> Feel free to come up with something different.  But, if your solution
> involves maintaining an additional read/write mount area in deference to
> a long dead unix tradition, I'm just going to shake my head and patch
> your solution away to something sane.
>
>   
I don't understand you argument here. Not the one where you say you're 
going to ignore Neil and do what you want because you can, I understand 
that, but the "additional read/write mount area" part, isn't /var/run 
r/w on all systems now? Could you clarify why this is "additional" here?

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

