From: Phil Turmel <philip@turmel.org>
Subject: Re: Looking for the best way to do this
Date: Thu, 23 Jun 2011 19:41:13 -0400
Message-ID: <4E03CF19.1040702@turmel.org>
References: <4E00DF31.2020406@gmail.com> <4E03929A.8000503@cdf.toronto.edu> <4E03B8DB.7010607@gmail.com> <4E03C444.6060406@turmel.org> <4E03CBC3.1080001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E03CBC3.1080001@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Maurice,

[restored CC list....  use reply-to-all on kernel.org lists]

On 06/23/2011 07:26 PM, maurice wrote:
> On 6/23/2011 4:55 PM, Phil Turmel wrote:
>> Hi maurice,
> 
> Hi Phil
> 
> That was great, thank you!
> 
> I gather that the R10 results ion a faster disk IO, in general?
> Probably with the  "far" version, if we are mostly reading?

For most applications, yes.  I haven't benchmarked it myself, though.

> I would be willing to lose redundancy for the duration of the creation process.
> Both disks presently seem to be OK.

You'll also be offline while copying and switching to the new filesystem.  Did you want layout=f2 or =f3 ?

> Any chance you could "wrap up" for me with the correct syntax for this?
> I find that the "trial and error " approach is less than optimal.

First, run a check on your array, to minimize the chance of a read error during the copy:

echo "check" >/sys/block/md*/md/sync_action

While that's running, send me the output of "lsdrv", which will let me give advice with real device names:

wget -O /usr/sbin/lsdrv http://github.com/pturmel/lsdrv/raw/master/lsdrv ; chmod 755 /usr/sbin/lsdrv ; lsdrv

Phil
