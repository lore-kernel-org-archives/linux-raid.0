From: Andre Tomt <andre@tomt.net>
Subject: Re: a general question re. linux-raid stability
Date: Tue, 21 Sep 2010 19:00:41 +0200
Message-ID: <4C98E4B9.60708@tomt.net>
References: <1284774145-14543-1-git-send-email-tmarri@apm.com> <20100918210920.E05AE157D71@gemini.denx.de> <7707889dee57e97ad50b4ce5c7697466@mail.gmail.com> <4C97DFB4.1010705@meetinghouse.net> <4C987A77.7050903@seoss.co.uk> <4C98D0C7.2000607@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C98D0C7.2000607@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/21/2010 05:35 PM, Miles Fidelman wrote:
> Tim Small wrote:
>> tim@zebedee:~$ zgrep -i raid
>> /usr/share/doc/linux-image-2.6.26-2-amd64/changelog.Debian.gz | egrep
>> -v '(aacraid|megaraid|cpq|5c1|dm|DM|cciss|LVM|sym)'
>> - md: handle writes to broken raid10 arrays gracefully
>> - md: raid10: fix use-after-free of bio
>> - md: Fix raid10 recovery problem.
>> - md: Avoid oops when attempting to fix read errors on raid10
> Uh oh. Now I am worried. I've been running 2.6.26-2-xen-686, on a couple
> of production machines, for a while now, on top of RAID10 - and that
> version of the kernel doesn't get a lot of attention.
>
> Sigh...

I wouln't worry about it, this is mostly churn, they add some, break 
some, fix some. The kernel that distributions release have been 
stabilized and 'frozen' for a good while meaning they are usually pretty 
safe, even if they can seem quite old. I'm also willing to bet that 
those fixes are mostly for corner cases rarely seen in the wild.

If you had been watching the linux-kernel list you'd be surprised your 
machines boot at all. ;)

Don't worry, be happy (until it blows up.)
