From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Broken harddisk
Date: Sat, 29 Jan 2005 10:31:40 -0800
Message-ID: <41FBD68C.4040701@h3c.com>
References: <200501291617.j0TGHG918839@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200501291617.j0TGHG918839@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Gordon Henderson' <gordon@drogon.net>, "'T. Ermlich'" <pelegrine@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Guy wrote:
> For future reference:
> 
> Everyone should do a nightly disk test to prevent bad blocks from hiding
> undetected.  smartd, badblocks or dd can be used.  Example:
> dd if=/dev/sda of=/dev/null bs=64k
> 
> Just create a nice little script that emails you the output.  Put this
> script in a nighty cron to run while the system is idle.

While I agree with your purpose 100% Guy, I respectfully disagree with 
the method. If at all possible, you should use tools that access the 
SMART capabilities of the device so that you get more than a read test - 
you also get statistics on the various other health parameters the drive 
checks some of which can serve fair warning of impending death before 
you get bad blocks.

http://smartmontools.sf.net is the source for fresh packages there, and 
smartd can be set up with a config file to do tests on any schedule you 
like, emailing you urgent results as it gets them, or just putting 
information of general interest in the logs that Logwatch picks up.

If you're drives don't talk SMART (older ones don't, it doesn't work 
through all interfaces either) then by all means take Guy's advice. A 
'dd' test is certainly valuable. But if they do talk SMART, I think its 
better

-Mike
