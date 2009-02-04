From: whollygoat@letterboxes.org
Subject: Re: zero-superblock, Re: some ?? re failed disk and resyncing of array
Date: Tue, 03 Feb 2009 20:48:06 -0800
Message-ID: <1233722886.30303.1298411647@webmail.messagingengine.com>
References: <1233389816.28363.1297740563@webmail.messagingengine.com>
 <49842A1E.1090105@dgreaves.com>
 <1233403388.29916.1297756217@webmail.messagingengine.com>
 <4985FAF1.2090208@tmr.com>
 <1233622333.26974.1298163227@webmail.messagingengine.com>
 <498804EF.6070102@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <498804EF.6070102@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 03 Feb 2009 08:48:47 +0000, 
"David Greaves" <david@dgreaves.com> said:
> whollygoat@letterboxes.org wrote:
> > Can anyone provide any more insight with the below?
> I agree the error messages don't help :)
> Old version of mdadm? IIRC the error reports are better now.

fly:~# mdadm -V
mdadm - v2.5.6 - 9 November 2006

debian 4.0
> 
> > fly:~# mdadm --zero-superblock /dev/hdk1
> > mdadm: Unrecognised md component device - /dev/hdk1
> It is likely that hdk1 is not an md component device and has no
> superblock.
> 
> > fly:~# mdadm -a /dev/hdk1
> > mdadm: /dev/hdk1 does not appear to be an md device
> Normally:
>   mdadm [mode] <raiddevice> [options] <component-devices>
> so:
>   mdadm /dev/md0 -a /dev/hdk1
> would work (otherwise which raid are you adding to?)

Doh!  This happened to me when I was failing and removing
drives to replace them with larger ones.  Either the error
message was clearer or I had my head screwed on tighter
'cause I managed to figure out what you've just pointed out:

fly:~# mdadm /dev/md/0 --zero-superblock /dev/hdk1

fly:~# mdadm /dev/md/0 -a /dev/hdk1
mdadm: added /dev/hdk1

Thanks.  I'm still concerned about the discrepancy between
--detail <array> and --examine <any-component-device>, 
especially since I just zeroed the superblock on k1.  That
is what --examine looks at isn't it?
fly:~# mdadm -D /dev/md/0
/dev/md/0:
[snip]
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0
[snip]
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

[snip]
    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1      34        1        1      active sync   /dev/hdg1
       2      56        1        2      active sync   /dev/hdi1
       5      89        1        3      active sync   /dev/hdo1
       6      88        1        4      active sync   /dev/hdm1

       7      57        1        -      spare   /dev/hdk1


fly:~# mdadm -E /dev/hdk1
/dev/hdk1:
[snip]
    Array Slot : 7 (0, 1, 2, failed, failed, 3, 4)
   Array State : uuuuu 2 failed

I recently tried to grow the array after replacing, one by 
one, 40G drives with the current 80 and 120G drives.  That
did not go smoothly and I ended up having to just recreate
the array.  I was getting the same kind of bad output from
--examine.

Before I could get the array fully restored from backup, I 
discovered some flaky hardware.  I suppose that could be
responsible for the strange Array Slot and State output above?
Either that or I am doing something seriously wrong.  Does it
seem reasonable to start from scratch again, now that I have
all the h/w issues worked out? or does it seem more like I'm
messing up the way I create it?

# mdadm -C /dev/md/0 -e 1.0 -v -l5 -b internal\
  -a yes -n 5 /dev/hde1 /dev/hdg1 /dev/hdi1 /dev/hdk1\
  /dev/hdm1 -x 1 /dev/hdo1 --name=<name>

wg
-- 
  
  whollygoat@letterboxes.org

-- 
http://www.fastmail.fm - mmm... Fastmail...

