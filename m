From: Luca Berra <bluca@comedia.it>
Subject: Re: EVMS causing problems with mdadm?
Date: Mon, 24 Apr 2006 00:02:45 +0200
Message-ID: <20060423220245.GA4050@percy.comedia.it>
References: <6d5bedd80604230833m3614f453we869b8bf7261d0e9@mail.gmail.com> <17483.62992.692017.319991@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17483.62992.692017.319991@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 24, 2006 at 07:48:00AM +1000, Neil Brown wrote:
>On Sunday April 23, ewan.grantham@gmail.com wrote:
>> Did my latest updates for my Kubuntu (Ubuntu KDE variant) this
>> morning, and noticed that EVMS has now "taken control" of my RAID
>> array. Didn't think much about it until I tried to make a RAID-1 array
>> with two disks I've just added to the system. Trying to do a create
>> verbose tells me that device /dev/md1 (or 2 or 3 - I tried a couple
>> just to see) doesn't exist. And in fact, there are no block devices
>> listed beyond md0.
>
>Sounds like udev is in use rather than a static /dev.
>
>Add '--auto=md' to the mdadm command line, and it will create the
>devices for you.  Or --auto=part if you want partitioned arrays.  See
>man page for more details.
>
>I suspect this might need to be come the default in another year or so....
>
i was tkinking about stat()ing "/dev/.udev" and automatically enabling
--auto if found

WDYT?

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
