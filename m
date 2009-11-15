From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mismatch_cnt again
Date: Sat, 14 Nov 2009 20:54:18 -0500
Message-ID: <4AFF5F4A.5000504@tmr.com>
References: <eyal@eyal.emu.id.au>	<200911121920.nACJKDew011818@wind.enjellic.com> <19196.50228.743428.552300@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19196.50228.743428.552300@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: greg@enjellic.com, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday November 12, greg@enjellic.com wrote:
>   
>> Neil/Martin what do you think?
>>     
>
> I think that if you found out which blocks were different and mapped
> that back through the filesystem, you would find that those blocks are
> not a part of any file, or possibly are part of a file that is
> currently being written.
>   

Well, I have a bunch on my /boot partition, so here's my test plan. 
Please comment on the safety of this plan as you see it.

- remount the raid-1 array read-only. It shouldn't be changing!
- mount 1st component r/o  and do md5sum on every file[1]
- for each other component, mount r/o and check every file

Investigate any mismatches found in real data.

The alternative involves taking the system down and doing this from a 
Live-CD. Since most of my servers and desktops (including this one) run 
in VMs on the server in question, this is safer but not likely to happen 
soon.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

