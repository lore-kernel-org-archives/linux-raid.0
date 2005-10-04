From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: Checking the sanity of SATA disks
Date: Tue, 04 Oct 2005 08:59:40 -0700
Message-ID: <4342A6EC.7090208@ucolick.org>
References: <20051004142913.GK6594@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051004142913.GK6594@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

There is a patch that can be applied to libata that enables SMART for 
SATA drives. It's not 100% stable, so running smartd is not recommended, 
but I've been running nightly SMART selftests and 5-minute temperature 
logging on our 8-drive array since June and has never run into a problem 
(though it's not a very heavily used machine). ymmv... See e.g. 
http://www.ussg.iu.edu/hypermail/linux/kernel/0408.3/2304.html

/Patrik

Andy Smith wrote:

>Hello,
>
>I have a home fileserver with 4 SATA disks in a RAID 5.  As I am
>sure you are aware, SATA devices in Linux currently cannot be
>queried for SMART info, so I can't do SMART health checks of these
>devices.
>
>Also there is still the tendency for Linux Software RAID to kick
>devices out of the array as soon as there is any error on them.
>
>I really don't want to be in the situation where a drive dies, I fit
>a new one, and during the resync another device is kicked out
>because of spontaneously finding a bad sector.
>
>I tried simply doing a
>
>        dd if=/dev/sd[abcd] of=/dev/null
>
>To check each disk in a very unsubtle fashion, but it drives the
>load average on the machine way way up (like to 20+) and makes it
>very unresponsive (wait several minutes for a keypress to be
>acknowledged), even if I run it under nice -n 19.
>
>I don't notice any performance problems on this server during normal
>day to day use, and while it's not particularly beefy it is an AMD
>Sempron 1.8GHz so I am surprised that simply reading from one disk
>causes these performance issues.
>
>I know this isn't right, so has anyone got any advice in the way of
>tracking down which part of the system is at fault, possibly
>off-list if it's too offtopic?
>
>Thanks,
>Andy
>  
>
>------------------------------------------------------------------------
>
>!DSPAM:434291cc89982461629467!
>
