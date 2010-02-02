From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Tue, 02 Feb 2010 13:18:58 -0500
Message-ID: <4B686C92.8000704@tmr.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	<1263242294-5353-3-git-send-email-dledford@redhat.com> <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com> <4B673A5D.2010901@tmr.com> <4B674860.7080604@redhat.com> <4B6758C7.9060301@tmr.com> <4B6869D2.7040506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6869D2.7040506@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> On 02/01/2010 05:42 PM, Bill Davidsen wrote:
>
>   
>> In other words, it's not where you put it, it's where you *didn't* put
>> it, that seems to be an
>> invitation to put stuff just anywhere. Neil argues that they are not
>> devices, I argue that
>> they are PIDs. It's not as though it were a huge effort to move it after
>> pivot root, it's a little code
>> or script and in space which will be released.
>>     
>
> On the pid files I see your point.  Not that it changes the problem, but
> it does at least point out that more needs to be done and that the
> current solution is incomplete.
>
>   
Good, and your point about context and such is well taken. I still feel 
that the way to
solve this would be to copy *just* the PID files to a real /var/run and 
any directories
being created would have default permissions. It just feels as if 
there's a single point
at which this could be done. And of course "if you broke it, you should 
fix it." That's
a popular thing Linus said, but the principle dates back to MULTICS, at 
least (70's).

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

