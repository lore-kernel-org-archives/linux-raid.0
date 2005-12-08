From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: Re: RAID5 problem
Date: Wed, 7 Dec 2005 20:49:50 -0500
Message-ID: <20051208014950.GA23381@jose.lug.udel.edu>
References: <4392FB7C.6080600@gmx.de> <17299.25606.806494.749914@cse.unsw.edu.au> <20051205014408.GA20602@jose.lug.udel.edu> <43977948.6050507@promotionstudios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43977948.6050507@promotionstudios.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Neale <james@promotionstudios.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 08, 2005 at 11:07:36AM +1100, James Neale wrote:
> Hi Ross
> I'm a bit of a mdadm newb and have been wrangling with -monitor rather 
> unsucccessfully.
> Currently  I'm manually checking /proc/mdstat until I've sorted out 
> something better.
> I'm running a single 1TB raid5 on 6 disks (one is spare) which has been 
> smooth so far.
> Any pointers or examples for that reliable noisy mailing beeping script 
> of yours in /etc/bashrc

The blob is below, just stick it in your bashrc.  My idea was that
everytime I spawn a shell (which is a lot!), mdstat gets checked.

What issues are you having with --monitor?  It should be pretty
automatic if you let it scan.  I just run something like this:

/sbin/mdadm -F -s -f -y

This stats mdadm in --monitor mode, scans for devices, daemonizes, and
records its results in syslog.

Here's what runs in my bashrc:

# Scream and cry a lot if the RAID looks weird!
if /bin/grep _ /proc/mdstat; then
        for ((scream = 0; scream < 5; scream ++)); do
                echo -e "POSSIBLE PROBLEM WITH RAID"
                sleep 0.1
        done
        cat /proc/mdstat
fi

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
