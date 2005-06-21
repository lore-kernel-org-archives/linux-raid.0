From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: from raidtools2 to mdadm
Date: Tue, 21 Jun 2005 16:25:48 +1000
Message-ID: <17079.45804.485652.77989@cse.unsw.edu.au>
References: <42B7A866.1080802@tequila.co.jp>
	<17079.43900.652982.735401@cse.unsw.edu.au>
	<42B7ACDA.1000605@tequila.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Clemens Schwaighofer on Tuesday June 21
Sender: linux-raid-owner@vger.kernel.org
To: Clemens Schwaighofer <cs@tequila.co.jp>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 21, cs@tequila.co.jp wrote:
> On 06/21/2005 02:54 PM, Neil Brown wrote:
> 
> >>#> mdadm --detail --scan>> mdadm.conf
> >>
> >>is enought to get the raid started the next time I have to reboot
> >>the box.
> > 
> > 
> > 1/ remove the 'devices=' parts.  Then it should be ok, providing there
> >    is a suitable DEVICES line at the top.
> 
> yeah I have a devices line on the top. If I don't have, I will need the
> devices lines I guess.

No..
The 'devices=' bits by themselves aren't enough, and are rarely
wanted.
If a device isn't listed in the DEVICES lines, then it won't be
considered for use in an array.

The 'devices=' words are quite different.  They say "this is how you
recognise a device that is in this array.  All the devices in it are
on this list".
This is reported by "mdadm --detail --scan" largely for interest.  It
should rarely be included in mdadm.conf.  The very latest version ofn
mdadm does not report them unless --verbose is given.

NeilBrown
