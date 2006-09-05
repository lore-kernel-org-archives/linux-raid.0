From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Care and feeding of RAID?
Date: Tue, 5 Sep 2006 18:02:21 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0609051749430.17570@lion.drogon.net>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net>
 <44FD91D1.7090501@maine.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FD91D1.7090501@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 5 Sep 2006, Steve Cousins wrote:

> Would people be willing to list their setup? Including such things as
> mdadm.conf file, crontab -l, plus scripts that they use to check the
> smart data and the array, mdadm daemon parameters and anything else that
> is relevant to checking and maintaining an array?

I don't have any mdadm.conf files ... What am I missing? (I've always been
under the impression that after needing the /etc/raidtab file with the old
raidtools, you didn't need a config file as such under mdadm...  However,
I'm willing to be enlightened!)

For checking the smart stuff, I use the standard Debian packages and a
smartd.conf file typically looks like:

#DEVICESCAN

/dev/hda -d ata -o on -S on -a -m smart-mon@domain.com -s (S/../.././04|L/../../1/20) -M daily -M test
/dev/hdc -d ata -o on -S on -a -m smart-mon@domain.com -s (S/../.././04|L/../../1/20) -M daily
/dev/hde -d ata -o on -S on -a -m smart-mon@domain.com -s (S/../.././04|L/../../1/20) -M daily
/dev/hdi -d ata -o on -S on -a -m smart-mon@domain.com -s (S/../.././04|L/../../1/20) -M daily

The running mdadm in monitor mode looks like:

  /sbin/mdadm -F -i /var/run/mdadm.pid -m root -f -s

and my weekly badblocks script looks like:

#!/bin/csh

echo "`uname -n`: Badblocks test starting at [`date`]"

foreach disk ( a c )
  foreach partition ( 1 2 3 5 6 )
    echo -n "hd$disk${partition}: "
    badblocks -c 128 /dev/hd$disk$partition
  end
  echo ""
end

echo "`uname -n`: Badblocks test   ending at [`date`]"

I do loads of stuff with disk temperatures (when I can), etc. but thats
just for making pretty graphs I can point at my customers... (eg
http://lion.drogon.net/mrtg/diskTemp.html and tell me when that data
centre upgraded their AC ;-)

Gordon
