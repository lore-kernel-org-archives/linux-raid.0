From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 problem
Date: Thu, 08 Dec 2005 09:20:40 +0000
Message-ID: <4397FAE8.6030009@dgreaves.com>
References: <4392FB7C.6080600@gmx.de> <17299.25606.806494.749914@cse.unsw.edu.au> <20051205014408.GA20602@jose.lug.udel.edu> <43977948.6050507@promotionstudios.com> <20051208014950.GA23381@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051208014950.GA23381@jose.lug.udel.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@jose.lug.udel.edu>
Cc: James Neale <james@promotionstudios.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ross Vandegrift wrote:

>On Thu, Dec 08, 2005 at 11:07:36AM +1100, James Neale wrote:
>  
>
>>Hi Ross
>>I'm a bit of a mdadm newb and have been wrangling with -monitor rather 
>>unsucccessfully.
>>Currently  I'm manually checking /proc/mdstat until I've sorted out 
>>something better.
>>I'm running a single 1TB raid5 on 6 disks (one is spare) which has been 
>>smooth so far.
>>Any pointers or examples for that reliable noisy mailing beeping script 
>>of yours in /etc/bashrc
>>    
>>
>
>The blob is below, just stick it in your bashrc.  My idea was that
>everytime I spawn a shell (which is a lot!), mdstat gets checked.
>
>What issues are you having with --monitor?  It should be pretty
>automatic if you let it scan.  I just run something like this:
>
>/sbin/mdadm -F -s -f -y
>
>This stats mdadm in --monitor mode, scans for devices, daemonizes, and
>records its results in syslog.
>
>Here's what runs in my bashrc:
>
># Scream and cry a lot if the RAID looks weird!
>if /bin/grep _ /proc/mdstat; then
>        for ((scream = 0; scream < 5; scream ++)); do
>                echo -e "POSSIBLE PROBLEM WITH RAID"
>                sleep 0.1
>        done
>        cat /proc/mdstat
>fi
>
>  
>
Have a look at monit
And festival

Quite a cool combination....


David




-- 

