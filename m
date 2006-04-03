From: Neil Brown <neilb@suse.de>
Subject: Re: Help recreating a raid5
Date: Mon, 3 Apr 2006 12:04:01 +1000
Message-ID: <17456.33425.813324.99020@cse.unsw.edu.au>
References: <442F8817.508@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Sunday April 2
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday April 2, david@dgreaves.com wrote:
> 
> >From some archive reading I understand that I can recreate the array using
> 
>    mdadm --create /dev/md1 -l5 -n3 /dev/sdd1 /dev/sdb1 missing
> 
> but that I need to specify the correct order for the drives.
> 
> I've not used --assume-clean, --force or --run; should I? I assume that
> since it's only got 2 of 3 then it won't need the assume-clean.
> 
> The detail and dmesg data suggests that the order in the command  above
> is correct.
> 
> Can anyone confirm this?

Yes, that all looks correct.

NeilBrown
