From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: a general question re. linux-raid stability
Date: Tue, 21 Sep 2010 11:35:35 -0400
Message-ID: <4C98D0C7.2000607@meetinghouse.net>
References: <1284774145-14543-1-git-send-email-tmarri@apm.com> <20100918210920.E05AE157D71@gemini.denx.de> <7707889dee57e97ad50b4ce5c7697466@mail.gmail.com> <4C97DFB4.1010705@meetinghouse.net> <4C987A77.7050903@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C987A77.7050903@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Small wrote:
> On 20/09/10 23:27, Miles Fidelman wrote:
>> I've been watching patch after patch go by on this list, which leads 
>> me to wonder - how stable are the basic raid kernel modules, and 
>> mdadm, as included in major linux distributions (in my case, Debian 
>> Lenny)?
> Pretty good - we use it on a few tens of servers.  Overall we find it 
> easier to manage, and more reliable than hardware RAID...
>
> Debian definitely gets updates - although the Debian team could 
> probably do with more help keeping tabs on them.  Two good 
> cross-reference sources are probably this list, and the RHEL kernel 
> update changelogs.....
>
> tim@zebedee:~$ cat /etc/debian_version
> 5.0.6
> tim@zebedee:~$ zgrep -i raid 
> /usr/share/doc/linux-image-2.6.26-2-amd64/changelog.Debian.gz | egrep 
> -v '(aacraid|megaraid|cpq|5c1|dm|DM|cciss|LVM|sym)'
>     - md: handle writes to broken raid10 arrays gracefully
>     - md: raid10: fix use-after-free of bio
>     - md: Fix raid10 recovery problem.
>     - md: Avoid oops when attempting to fix read errors on raid10
Uh oh.  Now I am worried.  I've been running 2.6.26-2-xen-686, on a 
couple of production machines, for a while now, on top of RAID10 - and 
that version of the kernel doesn't get a lot of attention.

Sigh...

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


